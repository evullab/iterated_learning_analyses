function entropy_sum=calc_entropy(fname_super,color_assign)
fname=fullfile(fname_super,'resp_entropy.mat');
if ~exist(fname)
    num_exp=length(unique(color_assign.exp_num));
    num_subj=length(unique(color_assign.subj));
    num_env=length(unique(color_assign.env_num));
    num_item=length(unique(color_assign.item_num));
    
    entropy_assign=nan(num_exp,num_subj,num_env,num_item,num_item);
    
    for i_exp=1:num_exp
        exp_ind=color_assign.exp_num==i_exp;
        curr_subjs=unique(color_assign.subj(exp_ind,:));
        
        
        for i_sub=1:length(curr_subjs)
            sub_ind=strcmp(color_assign.subj,curr_subjs{i_sub});
            curr_envs=unique(color_assign.env_num(exp_ind & sub_ind));
            if min(curr_envs)==0
                shift=1;
            elseif min(curr_envs)==1
                shift=0;
            end
            if (length(curr_envs)==25 & num_exp==2) | (length(curr_envs)==50 & num_exp==1) % Make sure subjects did all trials
                for i_env=curr_envs'
                    env_ind=color_assign.env_num==i_env;
                    objs_ind=find(exp_ind & sub_ind & env_ind);
                    if length(objs_ind)==num_item
                        for i = 1:length(objs_ind)
                            for j = 1:length(objs_ind)
                                
                                if color_assign.dot_color(objs_ind(i))==color_assign.dot_color(objs_ind(j))
                                    entropy_assign(i_exp,i_sub,i_env+shift,i,j)=1;
                                else
                                    entropy_assign(i_exp,i_sub,i_env+shift,i,j)=0;
                                end
                            end
                        end
                    end
                end
            end
        end
        
    end
    
    entropy_assign1=reshape(entropy_assign,num_exp*num_subj,num_env,num_item,num_item);
    entropy_assign2=squeeze(-nanmean(entropy_assign1,1).*log2(nanmean(entropy_assign1,1)));
    
    entropy_sum=nan(num_env,1);
    for ie=1:num_env
        entropy_curr=squeeze(entropy_assign2(ie,:,:));
        entropy_sum(ie)=sum(entropy_curr(~logical(eye(15))));
    end
    
    save(fname,'entropy_sum')
else
    load(fname)
end

end




