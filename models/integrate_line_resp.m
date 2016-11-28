function [new_mu,new_sd]=integrate_line_resp(targ,curr_id,old_group,new_group,assign,mod_params)
% Same as integrate_line, but objects are drawn to proportional points on
% line

curr_targ=targ(assign==curr_id,:);
num_in=size(curr_targ,1);
curr_cent=lineCenter(curr_targ);

%% Find proportional position on line

old_ang=(old_group.ang);
old_len=old_group.len;

% Find points on the line
the2=old_len/2;
shift2=the2*[cos(old_ang) sin(old_ang)]';

q_a=shift2+curr_cent; % point a
q_b=-shift2+curr_cent; % point b

allLinePro=nan(size(curr_targ));
for ii=1:size(curr_targ,1)
    [di dpo]=dist2point(q_a,q_b,curr_targ(ii,:),old_ang);
    allLinePro(ii,1:2)=pdist([q_a';dpo'])/old_len; % define proportional location relative to distance from point a
end

%% Identify corresponding points on new line

new_ang=atan(new_group.ang);
new_len=new_group.len;

% Find points on the line
the2=new_len/2;
shift2=the2*[cos(new_ang) sin(new_ang)]';

q_a2=shift2+curr_cent; % point a
q_b2=-shift2+curr_cent; % point b

if (pdist([q_a';q_a2'])+pdist([q_b';q_b2']))>(pdist([q_a';q_b2'])+pdist([q_b';q_a2']))
% unlikely, but if the line rotates enough, switch reference points
    q_a=q_b2;
    q_b=q_a2;
else
    q_a=q_a2;
    q_b=q_b2;
end

line_end_dif=(q_b-q_a)';

allLinePoint=repmat(q_a',size(allLinePro,1),1)+repmat(line_end_dif,size(allLinePro,1),1).*allLinePro;

%% Integrate line point and object memory

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
% new_sd=(obj_prec+clus_prec)^-1;




