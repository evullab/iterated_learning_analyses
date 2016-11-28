function new_group=update_any(curr_xy,curr_group,hyper_params)
new_group=curr_group;

if strcmp('clusterGaussianAnisotropic',curr_group.type)
    new_group.mean=mean(curr_xy,1);
    new_group.cov=updateStdMVN([hyper_params.prior_cov_clus],curr_xy);
elseif strcmp('clusterGaussianIsotropic',curr_group.type)
    new_group.mean=mean(curr_xy,1);
    iso_cov=eye(2)*(updateStdMVN_iso([hyper_params.prior_std_clus],curr_xy)^2);
    new_group.cov=iso_cov;
end

if ismember('clusterLine',{hyper_params.group_types}) && size(curr_xy,1)>=hyper_params(1).lineNum
    new_group.center=lineCenter(curr_xy);
    new_group.ang=updateSlopeLine(curr_xy,[hyper_params(1).lineSd]);
    new_group.len=updateLengthLine(curr_xy,[hyper_params(1).min_dist],1);
end