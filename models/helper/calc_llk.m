function llk=calc_llk(xy,samp,hyper_params)
% get log likelihood
llk=nan(size(xy,1),1);

groups=samp.groups;
assign=samp.assign;

for ig =1:length(groups)
    curr_group=groups(ig);
    curr_xy=xy(assign==curr_group.id,:);
    
    if strcmp(curr_group.type,'clusterGaussianIsotropic') || strcmp(curr_group.type,'clusterGaussianAnisotropic')
        llk(assign==curr_group.id)=mvnpdf(curr_xy,curr_group.mean,curr_group.cov);
        
    elseif strcmp(curr_group.type,'clusterLine')
        llk(assign==curr_group.id)=llk_line(curr_xy,curr_group,hyper_params);
    end

end

llk=log10(llk);

end