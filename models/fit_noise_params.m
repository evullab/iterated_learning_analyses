function [best_sigma,best_ang_noise,best_len_noise]=fit_noise_params(data,mod_params,exp_params,task_params)

%% Create file structure
sigma_fold_name='sigma_fits';
if ~exist(sigma_fold_name)
    mkdir(sigma_fold_name)
end

mod_fname=fullfile(sigma_fold_name,mod_params(1).mod_name);
if ~exist(mod_fname)
    mkdir(mod_fname)
end

%% Fit sigma

num_samps=200;
sigma_fname=fullfile(mod_fname,'sigma.mat');
sigma_range=mod_params.sigma_range;

% If the best fitting parameter has been saved
if ~exist(sigma_fname)
    

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


%% Fit line noise

line_noise_fname=fullfile(mod_fname,'line_noise.mat');
ang_noise_range=mod_params.ang_noise_range;
len_noise_range=mod_params.len_noise_range;

% If the best fitting parameter has been saved
if ~exist(line_noise_fname)

    % load groupings
    if ~exist('mle_samps')
        param_fname=fullfile(mod_fname,'best_alpha');
        mle_samps=grouping_model(param_fname,data,exp_params,task_params,mod_params,num_samps);
    end
    
    % Iterate over sigmas    
    all_llk=nan(length(ang_noise_range),length(len_noise_range));
    for ia = 1:length(ang_noise_range)
        for il = 1:length(len_noise_range)
            mod_params(1).line_ang=ang_noise_range(ia);
            mod_params(1).line_len=len_noise_range(il);
            line_ind_fname=fullfile(strcat(param_fname,'_fits'),strcat('line_llk','A',num2str(mod_params(1).line_ang),'L',num2str(mod_params(1).line_len),'.mat'));
            if ~exist(line_ind_fname)
                % Find llk of guesses given targets+grouping
                curr_llk=calc_llk_line(mod_fname,data,mle_samps,exp_params,mod_params,task_params);
            else
                load(line_ind_fname)
            end
            fclose all;
            all_llk(ia,il)=nanmedian(curr_llk(:)); 
        end
    end
    save(line_noise_fname,'all_llk')
else
    load(line_noise_fname);
end

[ang_min,len_min]=find(min(all_llk(:))==all_llk);
best_ang_noise=ang_noise_range(ang_min); % check if this works
best_len_noise=len_noise_range(len_min);


