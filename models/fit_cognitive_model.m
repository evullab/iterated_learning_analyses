function [mod_mle,mod_resp]=fit_cognitive_model(data,mod_params,dots_certain_exp_params,iterated_exp_params,task_params,hyper_params)

%% Fit alpha

% Located in dots_certain folder
best_alpha=fit_alpha2(mod_params,dots_certain_exp_params,task_params);
mod_params(1).alpha=best_alpha;

%% Fit noise

[best_sigma,best_ang_noise,best_len_noise]=fit_noise_params(data,mod_params,iterated_exp_params,task_params);
mod_params(1).sigma=best_sigma;
mod_params(1).ang_noise=best_ang_noise;
mod_params(1).len_noise=best_len_noise;

%% Run cognitive model
seeds=data(data.Iter==1,:);
num_samps=300;
[cogmod_mle,mod_resp]=run_cognitive_model(seeds,mod_params,iterated_exp_params,task_params,num_samps);

if strcmp(mod_params(1).mod_name,'line_hierarchy_v1')
    % grouping model uses the same parameters as the hierarchical line
    % model. can save some time
    mod_mle=cogmod_mle;
else
    clear cogmod_mle;
    %% Run grouping model on model responses
    group_fold='cogmod_groups';
    if ~exist(group_fold)
        mkdir(group_fold)
    end
    
    group_fname=fullfile(group_fold,strcat(mod_params(1).resp_name,'_group.mat'));
    if ~exist(group_fname)
        
        num_samps=300;
        fname=fullfile(group_fold,mod_params(1).resp_name);
        mod_data=resp2csv(mod_resp,iterated_exp_params);
        mod_mle=grouping_model(fname,mod_data,iterated_exp_params,task_params,hyper_params,num_samps);
        save(group_fname,'mod_mle')
    else
        load(group_fname)
    end
    
end


