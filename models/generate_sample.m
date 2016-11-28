function new_samp=generate_sample(xy,prev_samp,hyper_params)
% sample new cluster assignments and properties
    mod_samp_start=prev_samp;
    
    tau=randperm(size(xy,1));
    
    for it = tau
        % Remove item from group
        mod_samp_rem=remove_item(it,xy,mod_samp_start,hyper_params);
        line_id=strcmp('clusterLine',{mod_samp_rem.groups.type});
        if sum(line_id)>=2
            disp('')
        elseif sum(line_id)==1
            disp('') % plot_xy(xy(mod_samp_rem.assign==mod_samp_rem.groups(find(line_id)).id,:))
        end
        % reassign item
        mod_samp_reassign=assign_item(it,xy,mod_samp_rem,hyper_params);
        mod_samp_start=mod_samp_reassign;
        
    end
    
    % update groups and decide whether cluster or line
    new_samp=update_clusters(xy,mod_samp_start,hyper_params);
    
end


