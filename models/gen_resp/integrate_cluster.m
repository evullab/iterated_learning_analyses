function [new_mu,new_cov]=integrate_cluster(targ,curr_id,group,assign,all_mean,all_cov,mod_params)
% get means and precisions of encoded items

curr_targ=targ(assign==curr_id,:);
obj_noise=mod_params(1).sigma;
obj_prec=([obj_noise 0;0 obj_noise].^2)^-1;

num_in=sum(assign==curr_id);
clus_cov=group([group.id]==curr_id).cov;
num_group=length(unique(assign));

if num_in==1
    % If only 1 item, center bias
    clus_prec=((all_cov/num_group)+all_cov)^-1;
    cent=all_mean;
elseif num_in>1
    % If more than 1, cluster bias
    c_cov=clus_cov;
    clus_prec=((c_cov/num_in)+c_cov)^-1; 
    cent=mean(curr_targ);
end

nrm=(obj_prec+clus_prec)^-1;
obj=nrm*obj_prec*curr_targ';
clus=nrm*clus_prec*cent';

new_mu=(obj+repmat(clus,1,num_in))';
new_cov=(obj_prec+clus_prec)^-1;
