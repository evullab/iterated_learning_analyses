function [resp,new_mu,new_cov]=recall_hierarchical_lines(targ,curr_id,group,assign,mod_params,noise)
% Recall line and then recall objects biased towards line

curr_targ=targ(assign==curr_id,:);
num_in=size(curr_targ,1);
curr_cent=lineCenter(curr_targ);

%% Get features and noise of lines
is_line=find(strcmp('clusterLine',{group.type}));
lines_ang=nan(length(is_line),2);
lines_len=nan(length(is_line),2);
for il=1:length(is_line)
    ind_line=is_line(il);
    curr_line=group(ind_line);
    curr_line_obj=targ(assign==curr_line.id,:);

    % angle properties
    [beta,beta_mean,sd_beta]=updateSlopeLine(curr_line_obj,mod_params(1).lineSd); 
    
    % turn slope into angle
    rad_ang=atan(beta_mean);
    while rad_ang<0
        rad_ang=rad_ang+pi;
    end
    group(ind_line).beta_mean=rad_ang; 
    group(ind_line).beta_var=mod_params(1).ang_noise^2;

    % length properties
    theta=updateLengthLine(curr_line_obj,mod_params(1).min_dist,1);
    group(ind_line).theta_mean=log10(theta);
    group(ind_line).theta_var=mod_params(1).len_noise^2;

end


%% Recall integrate ensemble and individual line features

% choose angles with minimum distance between
beta_mat=repmat([group.beta_mean]',1,(length(is_line)-1)*2);
beta_mat(:,2)=beta_mat(:,2)-pi;

all_combs=combvec(beta_mat(1,:),beta_mat(2,:));
for i=3:size(beta_mat,1)
    all_combs=combvec(all_combs,beta_mat(i,:));
end
min_angs=all_combs(:,min(circ_var(all_combs,[],1))==circ_var(all_combs,[],1));
min_angs=min_angs(:,1);

for il=1:length(is_line)
    ind_line=is_line(il);
    group(ind_line).beta_mean=min_angs(il,1);
end

curr_group=group(curr_id==[group.id]);

% angle statistics
curr_prec_ang=curr_group.beta_var^-1;
mean_ang=circ_mean(min_angs);
ens_prec_ang=(circ_var(min_angs)/length([group.beta_mean]))^-1;

nrm_ang=(curr_prec_ang+ens_prec_ang)^-1;

curr_ang_weight=nrm_ang*curr_prec_ang;
ens_ang_weight=nrm_ang*ens_prec_ang;

temp_ang=circ_mean([curr_group.beta_mean;mean_ang],[curr_ang_weight;ens_ang_weight]);
recalled_ang=circ_vmrnd(temp_ang,nrm_ang^-1,1);

% length statistics
curr_prec_len=curr_group.theta_var^-1;
mean_len=mean([group.theta_mean],2);
ens_prec_len=(var([group.theta_mean],[],2)/length([group.theta_mean]))^-1;

nrm_len=(curr_prec_len+ens_prec_len)^-1;

curr_len_weight=nrm_len*curr_prec_len;
ens_len_weight=nrm_len*ens_prec_len;

temp_len=sum([curr_group.theta_mean;mean_len].*[curr_len_weight;ens_len_weight]);
recalled_len=10^normrnd(temp_len,sqrt(nrm_len),1);

%% Remember integrate memories of objects and recalled lines
old_group=group(curr_id==[group.id]);
new_group=group(curr_id==[group.id]);

new_group.ang=sin(recalled_ang)/cos(recalled_ang); % convert angle back to slope
new_group.len=recalled_len;

% [new_mu,new_cov]=integrate_line_resp(targ,curr_id,old_group,new_group,assign,mod_params);
% resp=mvnrnd(new_mu,new_cov+(noise));

[new_mu,new_sd]=integrate_line_resp(targ,curr_id,old_group,new_group,assign,mod_params);
resp=normrnd(new_mu,new_sd+(noise));



