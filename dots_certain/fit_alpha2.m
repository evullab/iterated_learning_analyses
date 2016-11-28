function best_alpha=fit_alpha2(mod_params,exp_params,task_params)
% 6/6/16-Created. Use data from dotsCertain color-grouping experiment to fit alpha
% 11/13/2016-For some reason I was trying to fit the average entropy instead of two products being in the same group... 

alpha_fold_name='alpha_fits';
if ~exist(alpha_fold_name)
    mkdir(alpha_fold_name)
end

%% Load data

% Data is split across two files from two different runs of experiment
color_env_fnames={'dots_certain_env_v1.mat','dots_certain_env_v2.mat'};
color_resp_fnames={'dots_certain_resp_v1.txt','dots_certain_resp_v2.txt'};

[certain_env,certain_resp]=read_dots_certain(color_env_fnames,color_resp_fnames);
total_env_num=50;
subj_fname=fullfile(alpha_fold_name,'subj_grouping_matrix.mat');
subj_groups=same_group_matrix(subj_fname,certain_env,certain_resp);

%% Response distribution

% entropy_resp=calc_entropy('dots_certain',certain_resp);

%% Fit model

mod_fname=fullfile(alpha_fold_name,mod_params(1).mod_name);
if ~exist(mod_fname)
    mkdir(mod_fname)
end

alpha_fname=fullfile(mod_fname,'alpha.mat');

if ~exist(alpha_fname)
    
    % Select environments
    certain_env.Seed=certain_env.env_num+((certain_env.exp_num-1)*max(certain_env.env_num));
    certain_env.Chain=ones(length(certain_env.exp_num),1);
    certain_env.Iter=ones(length(certain_env.exp_num),1);
    
    % Grid search
    
    % parameters
    num_samps=400;
    alpha_range=mod_params(1).alpha_range;
    mod_perform=nan(total_env_num,length(alpha_range));
    for i_a = 1:length(alpha_range)
        curr_alpha=alpha_range(i_a);
        mod_params(1).alpha=curr_alpha;
        
        param_fname=fullfile(mod_fname,strcat('param_',num2str(curr_alpha)));
        grouping_model(param_fname,certain_env,exp_params,task_params,mod_params,num_samps);
        all_samps=get_all_samps(param_fname,1:exp_params.numDisp,exp_params.numChains,exp_params.numIts);
        score=compare_grouping(subj_groups,all_samps);
        
        mod_perform(:,i_a)=score;
    end
    
    % Find best fit
    
    [a argmin]=min(mean(mod_perform,1));
    
    best_alpha=alpha_range(argmin);
    save(alpha_fname,'best_alpha')
else
    load(alpha_fname)
end


