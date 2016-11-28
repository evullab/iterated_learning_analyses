function llk=llk_line(xy,group,hyper_param)
llk=nan(size(xy,1),1);
hfT=group.len/2;
cB=group.ang;
shift=hfT*[cos(atan(cB)) sin(atan(cB))]';
Q1=shift+group.center;
Q2=-shift+group.center;
for i =1:size(xy,1)
    d=dist2point(Q1,Q2,xy(i,:),cB);
    llk(i)=(1/group.len)*normpdf(d,0,hyper_param(1).lineSd);
end