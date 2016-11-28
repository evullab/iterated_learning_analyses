function mod_samp=update_clusters(xy,mod_samp,hyper_params)

assign=mod_samp.assign;
groups=[mod_samp.groups];
num_items=length(assign);

%% Get cluster and, if relevant, line stats
new_group=[];
for ci=1:mod_samp.k
    curr_group=groups(ci);
    curr_xy=xy(assign==curr_group.id,:);
    group_prior=sum(assign==curr_group.id)/(num_items+hyper_params(1).alpha);
    curr_group.group_prior=group_prior;
    
    if ismember('clusterGaussianAnisotropic',{hyper_params.group_types})
        curr_group.type='clusterGaussianAnisotropic';
        curr_group=update_any(curr_xy,curr_group,hyper_params);
        clus_llk=mvnpdf(curr_xy,curr_group.mean,curr_group.cov);
    else
        curr_group.type='clusterGaussianIsotropic';
        curr_group=update_any(curr_xy,curr_group,hyper_params);
        clus_llk=mvnpdf(curr_xy,curr_group.mean,curr_group.cov);
    end
    
    % get line stats
    if size(curr_xy,1)>=[hyper_params(1).lineNum] && ismember('clusterLine',{hyper_params.group_types})
        curr_group.type='clusterLine';
        curr_group=update_any(curr_xy,curr_group,hyper_params);
        l_llk=llk_line(curr_xy,curr_group,hyper_params);
        
        % Decide whether group is cluster or line
        posterior=prod([clus_llk l_llk],1);
        sel=randsample(1:2,1,true,posterior);
       

        if sel==2
            curr_group.type='clusterLine';
        elseif sel==1
            if ismember('clusterGaussianAnisotropic',{hyper_params.group_types})
                curr_group.type='clusterGaussianAnisotropic';
            else
                curr_group.type='clusterGaussianIsotropic';
            end
            
        end
    end
    new_group=[new_group curr_group];
end
mod_samp.groups=new_group;

