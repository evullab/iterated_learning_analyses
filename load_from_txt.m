function [targX,targY,subjs]=load_from_txt(data,label,exp_params)

targX=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts,exp_params.numDots);
targY=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts,exp_params.numDots);
subjs=cell(exp_params.numDisp,exp_params.numChains,exp_params.numIts);

% trial type to search for
typeInd=strcmp(data{5},strcat(label,'_0')); % regular trial
typeInd2=strcmp(data{5},strcat(label,'_2')); % final trial

inpInd=(data{10}==2);
txInd=~strcmp(data{6},'');

for di=1:exp_params.numDisp
    for ci=1:exp_params.numChains
        % Find total number of iterations in this chain
        dispInd=data{2}==di;
        chainInd=data{3}==ci;
        ind1=find(dispInd & chainInd & typeInd & txInd);
        
        numActive=max(data{4}(ind1));
        numDone(di,ci)=numActive;
        if numActive>1
            for ii=1:numActive
                itsInd=data{4}==ii;
                ind2=find(dispInd & chainInd & itsInd & typeInd & txInd);
                subjs{di,ci,ii}=data{1}{ind2};
                tx=data{6}{ind2};
                ty=data{7}{ind2};
                
                tx2=regexp(tx,'a:15:{i:0|;s:\d*:"|";\d*i:\d*|";}','split');
                ty2=regexp(ty,'a:15:{i:0|;s:\d*:"|";\d*i:\d*|";}','split');
                
                tx3=tx2(3:2:end);
                ty3=ty2(3:2:end);
                
                for doti=1:exp_params.numDots
                    targX(di,ci,ii,doti)=str2num(tx3{doti});
                    targY(di,ci,ii,doti)=str2num(ty3{doti});
                end
                
                if ii==exp_params.numIts
                    % If it's the last iteration, get the dots7_2 trial
                    itsInd=data{4}==exp_params.numIts;
                    ind2=find(dispInd & chainInd & typeInd2 & txInd & itsInd);
                    try
                        tx=data{8}{ind2};
                    catch
                        disp('')
                    end
                    
                    ty=data{9}{ind2};
                    
                    
                    tx2=regexp(tx,'a:15:{i:0|;s:\d*:"|";\d*i:\d*|";}','split');
                    ty2=regexp(ty,'a:15:{i:0|;s:\d*:"|";\d*i:\d*|";}','split');
                    
                    tx3=tx2(3:2:end);
                    ty3=ty2(3:2:end);
                    
                    for doti=1:exp_params.numDots
                        xCurr(doti)=str2num(tx3{doti});
                        yCurr(doti)=str2num(ty3{doti});
                    end
                    
                    targX(di,ci,exp_params.numIts+1,:)=xCurr;
                    targY(di,ci,exp_params.numIts+1,:)=yCurr;
                    
                end
            end
        end
    end
end


