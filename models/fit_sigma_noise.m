function best_sigma=fit_sigma_noise(data,mod_params,exp_params,task_params)

%% Create file structure
sigma_fold_name='sigma_fits';
if ~exist(sigma_fold_name)
    mkdir(sigma_fold_name)
end

mod_fname=fullfile(sigma_fold_name,mod_params(1).mod_name);
if ~exist(mod_fname)
    mkdir(mod_fname)
end

sigma_fname=fullfile(mod_fname,'sigma.mat');
sigma_range=mod_params.sigma_range;

% If the best fitting parameter has been saved
if ~exist(sigma_fname)
    num_samps=100;

    % load groupings
    param_fname=fullfile(mod_fname,'best_alpha');
    mle_samps=grouping_model(param_fname,data,exp_params,task_params,mod_params,num_samps);

    % Iterate over sigmas    
    all_llk=nan(size(sigma_range));
    for is = 1:length(sigma_range)
        mod_params(1).sigma=sigma_range(is);
        sigma_ind_fname=fullfile(strcat(param_fname,'_fits'),strcat('sigma_llk',num2str(mod_params(1).sigma),'.mat'));
        if ~exist(sigma_ind_fname)
            % Find llk of guesses given targets+grouping
            curr_llk=calc_llk_sigma(mod_fname,data,mle_samps,exp_params,mod_params,task_params);
        else
            load(sigma_ind_fname)
        end
        fclose all;
        all_llk(is)=median(curr_llk(:)); % Check this
    end
    save(sigma_fname,'all_llk')
else
    load(sigma_fname);
end

[a argmin]=min(all_llk);
best_sigma=sigma_range(argmin);
