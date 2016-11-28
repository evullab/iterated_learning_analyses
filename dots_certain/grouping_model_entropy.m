function entropy_resp=grouping_model_entropy(fname,exp_params)
% get entropy of grouping model

fname2=fullfile(strcat(fname,'_fits'),'model_entropy.mat');
if ~exist(fname2)
    all_samps=get_all_samps(fname,1:exp_params.numDisp,exp_params.numChains,exp_params.numIts);
    
    exp_num=[];
    env_num=[];
    trial_num=[];
    item_num=[];
    dot_color=[];
    subj={};
    
    for id = 1:exp_params.numDisp
        
        curr_samps=all_samps{id};
        for is=1:length(curr_samps)
            curr_assign=curr_samps(is).assign;
            
            for ii = 1:length(curr_assign)
                exp_num=[exp_num;1];
                env_num=[env_num;id];
                item_num=[item_num;ii];
                dot_color=[dot_color; curr_assign(ii)];
                subj{end+1}=num2str(is);
            end
        end
        
    end
    
    certain_mod_resp=table(subj',exp_num,env_num,item_num,dot_color);
    certain_mod_resp.Properties.VariableNames = {'subj','exp_num','env_num','item_num','dot_color'};
    entropy_resp=calc_entropy(strcat(fname,'_fits'),certain_mod_resp);
    save(fname2,'entropy_resp');
else
    load(fname2)
end


end