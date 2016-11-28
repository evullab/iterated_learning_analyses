function mod_samp=remove_item(it,xy,mod_samp,hyper_params)

% Remove item from clusters
curr_c=mod_samp.assign(it);
mod_samp.assign(it)=nan;


% If cluster now empty, remove cluster
if sum(mod_samp.assign==curr_c)==0
    mod_samp.k=mod_samp.k-1;
    mod_samp.groups(curr_c==[mod_samp.groups.id])=[];
else
    curr_items=xy(mod_samp.assign==curr_c,:);
    ind_group=curr_c==[mod_samp.groups.id];
    if ismember('clusterGaussianAnisotropic',{hyper_params.group_types})
        % update cluster item was removed from (anisotropic)
        mod_samp.groups(ind_group).mean=mean(curr_items,1);
        mod_samp.groups(ind_group).cov=updateStdMVN([hyper_params.prior_cov_clus],curr_items);
    else
        % update cluster item was removed from (isotropic)
        mod_samp.groups(ind_group).mean=mean(curr_items,1);
        mod_samp.groups(ind_group).cov=updateStdMVN_iso([hyper_params.prior_std_clus],curr_items);
        
    end
    
%     if size(curr_items,1)>=[hyper_params(1).lineNum] && ismember('clusterLine',{hyper_params.group_types})
%         % update line item was removed from, if there are more than numline
%         % items
%         mod_samp.groups(ind_group).ang=updateSlopeLine(curr_items,[hyper_params(1).lineSd]);
%         mod_samp.groups(ind_group).center=lineCenter(curr_items);
%     end
    
    % adjust group prior
    mod_samp.groups(ind_group).group_prior=size(curr_items,1)/(size(xy,1)+hyper_params(1).alpha);
end


end