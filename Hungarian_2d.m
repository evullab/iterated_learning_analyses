function new_guess=Hungarian_2d(targ,guess)
% Rearrange guess to minimize euclidean distance with target
num_dots=size(targ,1);

xdif=((repmat(guess(:,1),1,num_dots)- repmat(targ(:,1)',num_dots,1)).^2);
ydif=((repmat(guess(:,2),1,num_dots)- repmat(targ(:,2)',num_dots,1)).^2);
distMat=sqrt(xdif+ydif);
hMap=Hungarian(distMat');
[a, curr2prev]=max(hMap,[],2);
new_guess=guess(curr2prev,:);

end