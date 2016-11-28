function [new_mu,new_sd]=integrate_line(targ,curr_id,group,assign,mod_params)

curr_targ=targ(assign==curr_id,:);
num_in=size(curr_targ,1);
curr_cent=lineCenter(curr_targ);
curr_group=group(curr_id==[group.id]);

% Line angle and length
ang=atan(curr_group.ang);
len=curr_group.len;

% Find points on the line
the2=len/2;
shift2=the2*[cos(ang) sin(ang)]';

q_a=shift2+curr_cent;
q_b=-shift2+curr_cent;

for ii=1:size(curr_targ,1)
    [di dpo]=dist2point(q_a,q_b,curr_targ(ii,:),ang);
    allLinePoint(ii,:)=dpo;
end

% Integrate line point and object memory
% Object noise
obj_noise=mod_params.sigma;
obj_prec=(obj_noise.^2)^-1;

% Linear bias
clus_noise=(mod_params(1).lineSd^2)/num_in;
clus_prec=(clus_noise)^-1;

nrm=(obj_prec+clus_prec)^-1;

% Weight clusters and objects by covariance
obj=nrm*obj_prec*curr_targ;
clus=nrm*clus_prec*allLinePoint;

new_mu=obj+clus;
new_sd=sqrt((obj_prec+clus_prec)^-1);

% % Object noise
% obj_noise=mod_params.sigma;
% obj_prec=([obj_noise 0;0 obj_noise].^2)^-1;
% 
% % Linear bias
% clus_noise=(mod_params(1).lineSd^2)/num_in;
% clus_prec=([clus_noise 0;0 clus_noise])^-1;
% 
% nrm=(obj_prec+clus_prec)^-1;
% 
% % Weight clusters and objects by covariance
% obj=nrm*obj_prec*curr_targ';
% clus=nrm*clus_prec*allLinePoint';
% 
% new_mu=(obj+clus)';
% new_cov=(obj_prec+clus_prec)^-1;



