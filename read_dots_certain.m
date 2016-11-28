function [certain_env,certain_resp]=read_dots_certain(color_env_fnames,color_resp_fnames)
% Read env and response files into coherent data formats...because i'm awful

%% Environment data
env_csv_fname=fullfile('dots_certain','data',strcat(color_env_fnames{1}(1:end-7),'.csv'));
if ~exist(env_csv_fname)
    exp_num=[];
    env_num=[];
    item_num=[];
    x_col=[];
    y_col=[];
    exp_count=1;
    for fname = color_env_fnames
        load(fullfile('dots_certain','data',fname{1}),'certainDisp')
        for disp = 1:length(certainDisp)
            curr_env=certainDisp{disp};
            num_item=size(curr_env,1);
            
            x_col=[x_col;curr_env(:,1)];
            y_col=[y_col;curr_env(:,2)];
            exp_num=[exp_num;repmat(exp_count,num_item,1)];
            env_num=[env_num;repmat(disp,num_item,1)];
            item_num=[item_num;(1:num_item)'];
        end
        exp_count=exp_count+1;
    end
    
    certain_env=table(exp_num,env_num,item_num,x_col,y_col);
    certain_env.Properties.VariableNames = {'exp_num','env_num','item_num','x','y'};
    writetable(certain_env,env_csv_fname,'Delimiter',',');
else
    certain_env=readtable(env_csv_fname);
end

%% Read responses

resp_csv_fname=fullfile('dots_certain','data',strcat(color_resp_fnames{1}(1:end-7),'.csv'));
if ~exist(resp_csv_fname)
    exp_num=[];
    env_num=[];
    trial_num=[];
    item_num=[];
    dot_color=[];
    subj={};
    
    exp_count=1;
    for fname = color_resp_fnames
        datafile=fopen(fullfile('dots_certain','data',fname{1}));
        data =textscan(datafile,'%s %s %f %s %f ', 'delimiter','$');
        
        all_subj=data{1};
        env_n=data{3};
        resp=data{4};
        for it =1:length(all_subj)
            curr_subj=all_subj{it};
            curr_env=env_n(it)+1;
            ind_resp_temp=resp{it}(3:end-2);
            ind_resp=strsplit(ind_resp_temp,'","');
            uni_resp=unique(ind_resp);
            
            for ir = 1:length(ind_resp)
                exp_num=[exp_num;exp_count];
                env_num=[env_num;curr_env];
                item_num=[item_num;ir];
                trial_num=[trial_num;it];
                ind=find(strcmp(ind_resp{ir},uni_resp));
                dot_color=[dot_color;ind];
                subj{end+1}=curr_subj;
            end
            
        end
        
        exp_count=exp_count+1;
    end
    
    certain_resp=table(subj',exp_num,env_num,item_num,trial_num,dot_color);
    certain_resp.Properties.VariableNames = {'subj','exp_num','env_num','item_num','trial_num','dot_color'};
    writetable(certain_resp,resp_csv_fname,'Delimiter',',');
    
else
    
    certain_resp=readtable(resp_csv_fname);
    
end

end


