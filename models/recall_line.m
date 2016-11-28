function resp=recall_line(targ,curr_id,group,assign,mod_params,noise)
% Recall line and then recall objects biased towards line

curr_targ=targ(assign==curr_id,:);
num_in=size(curr_targ,1);
curr_cent=lineCenter(curr_targ);
curr_group=group(curr_id==[group.id]);

% Recall line features

[beta,beta_1,sd_beta]=updateSlopeLine(curr_targ,mod_params(1).lineSd);
theta=updateLengthLine(curr_targ,mod_params(1).min_dist,1);

% Remember integrate memories of objects and recalled lines
old_group=group(curr_id==[group.id]);
new_group=group(curr_id==[group.id]);
new_ang=circ_vmrnd(atan(beta),1/(mod_params(1).ang_noise^2),1);
new_group.ang=new_ang;
new_group.beta=tan(new_ang);
new_group.theta=10^normrnd(log10(theta),mod_params(1).len_noise);

% [new_mu,new_cov]=integrate_line_resp(targ,curr_id,old_group,new_group,assign,mod_params);
% resp=mvnrnd(new_mu,new_cov+(noise));

[new_mu,new_sd]=integrate_line_resp(targ,curr_id,old_group,new_group,assign,mod_params);
resp=normrnd(new_mu,new_sd+(noise));

