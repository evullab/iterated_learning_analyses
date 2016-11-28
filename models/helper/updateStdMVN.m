function covy=updateStdMVN(p_cov,xy)
v=2;
nCItem=size(xy,1);
mu=nCItem+v;

smean=mean(xy,1);
tempsum=0;
temp=repmat(smean,nCItem,1)-xy;
for i=1:nCItem
    tempsum=tempsum+temp(i,:)'*temp(i,:);
end
covy=iwishrnd(p_cov+tempsum,mu);