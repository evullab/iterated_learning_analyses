function [theta,theta_mean,theta_sd]=updateLengthLineLog(locs,p_dist,v)
k=size(locs,1);
maxdist=log10(max([pdist(locs)]));
[theta,theta_mean,theta_sd]=randp(1,1,k+v,maxdist);