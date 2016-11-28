function [theta,theta_mean,theta_sd]=updateLengthLine(locs,p_dist,v)
k=size(locs,1);
% min_len=p_dist*(2*(k-1)); % has to be enough length to fit dots without overlapping
maxdist=max([pdist(locs)]);
[theta,theta_mean,theta_sd]=randp(1,1,k+v,maxdist);