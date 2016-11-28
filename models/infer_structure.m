function structure_samples=infer_structure(xy,hyper_params,num_samps)
% Run model fitting
% 5.13.2016-Created. Cleaning up from earlier dirichGibbs16_v15.m

num_items=size(xy,1);

%% Prior distribution on clusters


%% Initialize all items in cluster
init_samp=create_empty_samp();
init_samp.k=1;
init_samp.assign=ones(num_items,1);

if ismember('clusterGaussianAnisotropic',{hyper_params.group_types})
    % Start off in anisotropic cluster
    init_samp.groups=[group_struc(1,'clusterGaussianAnisotropic', ...
        [hyper_params.prior_mean],[hyper_params.prior_cov], nan,nan,nan,num_items/(num_items+hyper_params(1).alpha))];
else
    % Start with isotropic cluster
    init_samp.groups=[group_struc(1,'clusterGaussianIsotropic', ...
        [hyper_params.prior_mean],[eye(2)*([hyper_params(1).prior_std]^2)], nan,nan,nan,num_items/(num_items+hyper_params(1).alpha))];
end

init_samp.llk=calc_llk(xy,init_samp,hyper_params);
structure_samples=[init_samp];

%% Iterate
for is =2:num_samps
    
    new_samp=samp_struc(xy,structure_samples(is-1),hyper_params);
    structure_samples=[structure_samples new_samp];
    
end


end