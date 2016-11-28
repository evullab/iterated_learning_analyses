function best_alpha=fit_alpha(mod_params,exp_params,task_params)
% 6/6/16-Created. Use data from dotsCertain color-grouping experiment to fit alpha

alpha_fold_name='alpha_fits';
if ~exist(alpha_fold_name)
    mkdir(alpha_fold_name)
end

%% Load data

% Data is split across two files from two different runs of experiment
color_env_fnames={'dots_certain_env_v1.mat','dots_certain_env_v2.mat'};
color_resp_fnames={'dots_certain_resp_v1.txt','dots_certain_resp_v2.txt'};

[certain_env,certain_resp]=read_dots_certain(color_env_fnames,color_resp_fnames);

%% Response distribution

entropy_resp=calc_entropy('dots_certain',certain_resp);

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
    num_samps=100;
    alpha_range=mod_params(1).alpha_range;
    entropy_predict=nan(length(entropy_resp),length(alpha_range));
    for i_a = 1:length(alpha_range)
        curr_alpha=alpha_range(i_a);
        mod_params(1).alpha=curr_alpha;
        
        param_fname=fullfile(mod_fname,strcat('param_',num2str(curr_alpha)));
        grouping_model(param_fname,certain_env,exp_params,task_params,mod_params,num_samps);
        entropy_model=grouping_model_entropy(param_fname,exp_params);
        entropy_predict(:,i_a)=entropy_model;
    end
    
    % Find best fit
    
    dist=sqrt(sum((repmat(entropy_resp,1,length(alpha_range))-entropy_predict).^2,1));
    [a argmin]=min(dist);
    
    best_alpha=alpha_range(argmin);
    save(alpha_fname,'best_alpha')
else
    load(alpha_fname)
end


