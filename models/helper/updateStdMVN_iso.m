function cv=updateStdMVN_iso(sdPrior,xy)
center=mean(xy);
distsI=abs(reshape(xy-repmat(center,size(xy,1),1),numel(xy),1));
distsI=[sdPrior;distsI];

dfVar = nansum(distsI.^2);
df = sum(~isnan(distsI));
p1 = df/2;
p2 = dfVar/2;
sd=sqrt(1./gamrnd(p1,1./p2));

cv=eye(2)*(sd^2);

end