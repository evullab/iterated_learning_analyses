function all_groups=same_group_matrix(alpha_fname,certain_env,certain_resp)
% 11/13/2016-Given responses from grouping experiment, create an n X n
% matrix of the probability of two objects being in the same group

if ~exist(alpha_fname)
    disp('Grouping subject responses')
    all_groups={};

    for exp =1:max(certain_env.exp_num)
        for env =1:max(certain_env.env_num)
            disp(env*exp)
            curr_resp=certain_resp(certain_resp.env_num==env*exp,:);
            curr_mat=zeros(15,15);
            curr_subjs=unique(curr_resp.subj);
            for subj = 1:length(curr_subjs)
                curr_resp2=curr_resp(strcmp(curr_resp.subj,curr_subjs(subj)),:);
                if length(curr_resp2.subj)==15
                     curr_mat=curr_mat+double(repmat(curr_resp2.dot_color,1,15)==repmat(curr_resp2.dot_color',15,1));
                end
            end
            curr_mat_prop=curr_mat/curr_mat(1,1);
            all_groups{end+1}=curr_mat_prop;

        end
    end
    save(alpha_fname,'all_groups')
else 
    load(alpha_fname)
end


end