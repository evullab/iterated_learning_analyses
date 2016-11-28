function mod_samp=assign_item(it,xy,mod_samp,hyper_params)

assign=mod_samp.assign;
num_items=length(assign);
groups=[mod_samp.groups];
curr_xy=xy(it,:);

% number of items per cluster
num_c=zeros(1,length(groups));
for ig =1:length(groups)
    num_c(ig)=sum(groups(ig).id==assign);
end

prior=[num_c hyper_params(1).alpha]/sum([num_c hyper_params(1).alpha]);

%% likelihood of individual groups and new proposal

clus_llk=nan(1,mod_samp.k);
for ci=1:mod_samp.k
    curr_group=groups(ci);
    if strcmp('clusterGaussianAnisotropic',curr_group.type)
        % If it is a cluster
        clus_llk(ci)=mvnpdf(curr_xy,curr_group.mean,curr_group.cov);
    elseif strcmp('clusterGaussianIsotropic',curr_group.type)
        clus_llk(ci)=mvnpdf(curr_xy,curr_group.mean,curr_group.cov);
    elseif strcmp('clusterLine',curr_group.type)
        % If it is a line
        clus_llk(ci)=llk_line(curr_xy,curr_group,hyper_params);
    end
end

% new cluster
if ismember('clusterGaussianAnisotropic',{hyper_params.group_types})
    clus_llk(mod_samp.k+1)=mvnpdf(xy(it,:),[hyper_params.prior_mean],[hyper_params.prior_cov]);
else
    clus_llk(mod_samp.k+1)=mvnpdf(xy(it,:),[hyper_params.prior_mean],eye(2)*([hyper_params(1).prior_std]^2));
end

%% Sample

posterior=prior.*clus_llk;
sel=randsample(1:length(posterior),1,true,posterior);


% add a new cluster
if sel==(mod_samp.k+1)
    mod_samp.k=mod_samp.k+1;
    
    next_ind=min(setdiff([1:max(mod_samp.assign) (max(mod_samp.assign)+1)],mod_samp.assign ));
    mod_samp.assign(it)=next_ind;

    if ismember('clusterGaussianAnisotropic',{hyper_params.group_types})
        mod_samp.groups(end+1)=group_struc(next_ind,'clusterGaussianAnisotropic', ...
            curr_xy,updateStdMVN([hyper_params.prior_cov_clus],curr_xy),nan,nan,nan,1/(num_items+hyper_params(1).alpha));
    else
        mod_samp.groups(end+1)=group_struc(next_ind,'clusterGaussianIsotropic', ...
            curr_xy,updateStdMVN_iso([hyper_params.prior_std_clus],curr_xy),nan,nan,nan,1/(num_items+hyper_params(1).alpha));
    end

% update cluster/line that the item has been added to
else
    mod_samp.assign(it)=mod_samp.groups(sel).id;
    curr_xy=xy(mod_samp.assign==mod_samp.groups(sel).id,:);
    groups=[mod_samp.groups];
    curr_group=groups(sel);
        
    mod_samp.groups(sel)= update_any(curr_xy,curr_group,hyper_params);
    mod_samp.groups(sel).group_prior=size(curr_xy,1)/(num_items+hyper_params(1).alpha);
end






