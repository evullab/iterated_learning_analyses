%% main
% 5.13.2016-Created. Run all analyses
addpath('circ_stat');
addpath('models');
addpath('models/helper');
addpath('models/plot_groupings');
addpath('models/gen_resp');
addpath('figures');
addpath('figures/behavioral');
addpath('figures/individual_plots');
addpath('figures/comparison_plots');
addpath('dots_certain');

figure_fold='figures/figure_csv';

set(0,'defaultlinelinewidth',4)

exp_params=struct('numDisp',10,'numChains',10,'numIts',20,'numDots',15);
task_params=struct('dotSize',10,'envRad',275);

%% Load data
mem_fname='dots_memory';
exp_id='dots6';
mem_data=txt_data2csv(mem_fname,exp_id,exp_params);

mem_fname='dots_perc';
exp_id='dots8';
perc_data=txt_data2csv(mem_fname,exp_id,exp_params);

%% Run grouping model on human results
% alpha is set based on line models
hyper_params=struct('alpha',.0814, ...
'group_types',{'clusterGaussianIsotropic','clusterLine','clusterGaussianAnisotropic'}, ...
'lineNum',4,'lineSd',2.5);

num_samps=800;
fname='group_memory';
all_mle=grouping_model(fname,mem_data,exp_params,task_params,hyper_params,num_samps);

num_samps=800;
fname='group_perc';
perc_mle=grouping_model(fname,perc_data,exp_params,task_params,hyper_params,num_samps);

% plot_all_groupings(fname,mem_data,all_mle,exp_params);

file_prefix='subj';
results_fold=fullfile(figure_fold,file_prefix);

if ~exist(results_fold)
    mkdir(results_fold)
end

% Number of groups
subj_k=analyze_num_groups(all_mle,exp_params);

% Analyze translational error correlation
[same_err_corr,diff_err_corr]=analyze_err_corr(mem_data,all_mle,exp_params);

% Analyze dispersion groups
subj_dispersion=analyze_dispersion_groups(all_mle,exp_params);

% Proportion of lines
subj_lines=analyze_prop_lines(all_mle,exp_params);

% Line Similarity
[subj_ang_sim_prop,subj_len_sim_prop]=analyze_similarity_lines(all_mle,exp_params); % proportion
[sub_ang_sim_prop_ci,sub_len_sim_prop_ci]=analyze_similarity_lines_ci(all_mle,exp_params); % proportion

% results2csv(file_prefix,results_fold,exp_params,subj_k,subj_dispersion,subj_lines,subj_ang_sim,subj_len_sim);
% results2csv_sim_prop(file_prefix,results_fold,exp_params,subj_ang_sim_prop,subj_len_sim_prop);

%% Fit models

% Define models

% Using calculation uncertainty for length and angle noise
line_hierarchy_hyper_params=struct('alpha',.25, ...
    'group_types',{'clusterGaussianIsotropic','clusterLine','clusterGaussianAnisotropic'}, ...
    'lineNum',4, ...
    'lineSd',2.5, ...
    'mod_name','line_hierarchy_v1', ... % For alpha and sigma fitting
    'resp_name','line_hierarchy_v1', ... % For model responses
    'line_hier',true, ... % does the grouping algorithm infer lines?
    'alpha_range',{linspace(.03,.15,15)}, ... % dirichlet concentration parameter
    'sigma_range',{linspace(40,80,9)}, ... % object noise parameter
    'ang_noise_range',{linspace(.1,pi/2,10)}, ... % line angle noise for von mises
    'len_noise_range',{linspace(.05,.15,10)}, ... % line length noise for log-normal
    'fname','Line Hierarchy' ...
    );

line_hyper_params=struct('alpha',.25, ...
    'group_types',{'clusterGaussianIsotropic','clusterLine','clusterGaussianAnisotropic'}, ...
    'lineNum',4, ...
    'lineSd',2.5, ...
    'mod_name','line_v1', ... % same grouping algorithm as hierarchical line
    'resp_name','line_v1', ...
    'line_hier',false, ...
    'alpha_range',{linspace(.001,.2,10)}, ... % dirichlet concentration parameter # linspace(.005,.03,8)
    'sigma_range',{linspace(40,80,9)}, ... % object noise parameter
    'ang_noise_range',{linspace(.1,pi/2,10)}, ... % line angle noise for von mises
    'len_noise_range',{linspace(.05,.15,10)}, ... % line length noise for log-normal
    'fname','Line Model' ...
    );


anisotropic_hyper_params=struct('alpha',.25, ...
    'group_types',{'clusterGaussianIsotropic','clusterGaussianAnisotropic'}, ...
    'lineNum',4, ...
    'lineSd',2.5, ...
    'mod_name','anisotropic_v1', ...
    'resp_name','anisotropic_v1', ...
    'line_hier',false, ...
    'alpha_range',{linspace(.1,.4,10)}, ...
    'sigma_range',{linspace(10,50,9)}, ...
    'ang_noise_range',{0}, ... % unused-model doesn't have lines
    'len_noise_range',{0}, ... 
    'fname','Anisotropic' ...
    );

isotropic_hyper_params=struct('alpha',.25, ...
    'group_types',{'clusterGaussianIsotropic'}, ...
    'lineNum',4, ...
    'lineSd',2.5, ...
    'mod_name','isotropic_v1', ...
    'resp_name','isotropic_v1', ...
    'line_hier',false, ...
    'alpha_range',{linspace(.1,.4,10)}, ...
    'sigma_range',{linspace(10,50,9)}, ...
    'ang_noise_range',{0}, ... % unused-model doesn't have lines
    'len_noise_range',{0}, ... 
    'fname','Isotropic' ...
    );

all_models={line_hierarchy_hyper_params,line_hyper_params,anisotropic_hyper_params,isotropic_hyper_params};
% all_models={line_hierarchy_hyper_params,line_hyper_params};

dots_certain_exp_params=struct('numDisp',50,'numChains',1,'numIts',1,'numDots',15);

all_mod_mle={};
all_mod_dispersion={};
all_mod_line_prop={};
all_mod_line_ang={};
all_mod_line_len={};

% Fit model and analyze results
for im =1:length(all_models)
    
    curr_model=all_models{im};
    curr_model_name=curr_model(1).resp_name;
    disp(curr_model_name)
    
    % Fit model
    [mod_mle,mod_resp]=fit_cognitive_model(mem_data,curr_model,dots_certain_exp_params,exp_params,task_params,hyper_params);
    all_mod_mle{im}=mod_mle;
    
    % Number of groups
    mod_k=analyze_num_groups(mod_mle,exp_params);
    
    % Analyze dispersion groups
    mod_dispersion=analyze_dispersion_groups(mod_mle,exp_params);
    all_mod_dispersion{im}=mod_dispersion;
    
    % Proportion of lines
    mod_lines=analyze_prop_lines(mod_mle,exp_params);
    all_mod_line_prop{im}=mod_lines;
    
    % Line Similarity
    [mod_ang_sim_prop,mod_len_sim_prop]=analyze_similarity_lines(mod_mle,exp_params); % proportion
    all_mod_line_ang{im}=mod_ang_sim_prop;
    all_mod_line_len{im}=mod_len_sim_prop;
    
    file_prefix=curr_model_name;
    results_fold=fullfile(figure_fold,curr_model_name);
    if ~exist(results_fold)
        mkdir(results_fold)
    end
%     results2csv(file_prefix,results_fold,exp_params,mod_k,mod_dispersion,mod_lines,mod_ang_sim,mod_len_sim);
%     results2csv_sim_prop(file_prefix,results_fold,exp_params,mod_ang_sim_prop,mod_len_sim_prop);
    clc;
end


%% Plot behavioral

analyze_iteration_dist(mem_data,exp_params)

plot_sequential('data/n_back.csv',[1.5,1.75,2.0,2.25])

plot_nn('data/NN_iter.csv',[-.5,-.25,0])

%% Plot subject results

plot_err_corr(same_err_corr,diff_err_corr,[0,.2,.4,.6])

plot_dispersion(subj_dispersion)

plot_line_proportion(subj_lines,[0,.1,.2,.3])

plot_line_ang(subj_ang_sim_prop,[.1,.3,.5,.7],sub_ang_sim_prop_ci)

% plot_line_len(subj_len_sim_prop,[.1,.3,.5,.7],sub_len_sim_prop_ci)

%% Subject vs Model comparisons

plot_compare_dispersion(subj_dispersion,all_mod_dispersion(4),all_models(4))

plot_compare_line_prop(subj_lines,all_mod_line_prop([4,3,2]),all_models([4,3,2]))

plot_compare_line_ang(subj_ang_sim_prop,all_mod_line_ang([2,1]),all_models([2,1]),sub_ang_sim_prop_ci)

% plot_compare_line_len(subj_len_sim_prop,all_mod_line_len([2,1]),all_models([2,1]),sub_len_sim_prop_ci)

