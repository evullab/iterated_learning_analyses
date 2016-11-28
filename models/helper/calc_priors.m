function hyper_params=calc_priors(xy,hyper_params,task_params)

hyper_params(1).prior_mean=mean(xy,1); % Mean of locs for initial cluster

if ismember('clusterGaussianAnisotropic',{hyper_params.group_types})
    
    hyper_params(1).prior_cov=cov(xy); % Prior for global prior
    hyper_params(1).prior_cov_clus=eye(2)*mean(var(xy))/4; % Prior for cluster std
    
elseif ismember('clusterGaussianIsotropic',{hyper_params.group_types})
    priorSd=std(reshape(xy-repmat(hyper_params.prior_mean,size(xy,1),1),numel(xy),1));
    priorVar=priorSd.^2;
    hyper_params(1).prior_std=priorSd;
    hyper_params(1).prior_std_clus=sqrt(priorVar/4);
end
if ismember('clusterLine',{hyper_params.group_types})
    hyper_params(1).min_dist=task_params.dotSize;
end