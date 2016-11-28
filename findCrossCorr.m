function cCorr=findCrossCorr(currGuess,currTarg)
% v2-Modified to work with any clustering
% v5-Taking max
currDifs=currGuess-currTarg;

% Cross Correlations
cCorr=nan(size(currGuess,1),size(currGuess,1));
for m=1:size(currGuess,1)
    for n=1:size(currGuess,1)
        total=(currDifs(m,:)*currDifs(n,:)')/(max([norm(currDifs(m,:)) norm(currDifs(n,:))])^2);
        cCorr(m,n)=total;
    end
end
cCorr(logical(eye(length(cCorr))))=nan;



end