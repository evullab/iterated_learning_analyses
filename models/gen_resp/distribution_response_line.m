function line_output=distribution_response_line(targ,infer_struc,guess,mod_params,task_params)
% Acts as either pdf for line angle and length

group=infer_struc.groups;
assign=infer_struc.assign;
num_dots=length(assign);

all_mean=mean(targ,1);
all_cov=cov(targ);
num_group=length(group);
num_line=sum(strcmp('clusterLine',{group.type}));
is_pdf=~isnan(guess);

%% match target to guess
guess_map=Hungarian_2d(targ,guess);
line_output=nan(num_group,1); % output llk of lines

%% Calculate statistics of line(s)

all_targ_ang=nan(num_group,1);
all_targ_len=nan(num_group,1);
if num_line>0
    for ig=1:num_group
        curr_group=group(ig);
        if strcmp(curr_group.type,'clusterLine')
            curr_id=curr_group.id;
            curr_targ=targ(assign==curr_id,:);
            [all_targ_ang(ig),all_targ_len(ig)]=fit_pca_line(curr_targ);
        end
    end
    
    mean_ang=circ_mean(all_targ_ang(~isnan(all_targ_ang)));
    ens_prec_ang=(circ_var(all_targ_ang(~isnan(all_targ_ang)))/num_line)^-1;

    mean_len=mean(log10(all_targ_len(~isnan(all_targ_len))));
    ens_prec_len=(var(all_targ_len(~isnan(all_targ_len)))/num_line)^-1;

end

%% calculate llk for objects from each group

for ig=1:num_group
    % get current group and items
    curr_group=group(ig);
    curr_id=curr_group.id;
    curr_targ=targ(assign==curr_id,:);
    curr_guess=guess_map(assign==curr_id,:);
    
    
    if strcmp(curr_group.type,'clusterGaussianAnisotropic') || strcmp(curr_group.type,'clusterGaussianIsotropic')
        % If cluster, ignore
        line_output(ig)=nan;%-log(realmin());
    else
        targ_ang=all_targ_ang(ig);
        targ_len=all_targ_len(ig);
        [guess_ang,guess_len]=fit_pca_line(curr_guess);
        if num_line==1
            ang_llk=circ_vmpdf(targ_ang,guess_ang,1/(mod_params(1).line_ang^2));
            len_llk=normpdf(log10(targ_len),log10(guess_len),mod_params(1).line_len);
            line_output(ig)=-log(nansum([ang_llk,eps]))-log(len_llk+eps);
        else
            % ensemble angle 
            curr_prec_ang=mod_params(1).line_ang^-2;
            nrm_ang=(curr_prec_ang+ens_prec_ang)^-1;
            
            curr_ang_weight=nrm_ang*curr_prec_ang;
            ens_ang_weight=nrm_ang*ens_prec_ang;
            
            temp_ang=circ_mean([targ_ang;mean_ang],[curr_ang_weight;ens_ang_weight]);
            ang_llk=circ_vmpdf(temp_ang,guess_ang,nrm_ang^-1);
            
            % length statistics
            curr_prec_len=mod_params(1).line_len^-2;
            nrm_len=(curr_prec_len+ens_prec_len)^-1;
            
            curr_len_weight=nrm_len*curr_prec_len;
            ens_len_weight=nrm_len*ens_prec_len;
            
            temp_len=sum([targ_len;mean_len].*[curr_len_weight;ens_len_weight]);
            len_llk=normpdf(temp_len,guess_len,sqrt(nrm_len));
            line_output(ig)=-log(nansum([ang_llk,eps]))-log(len_llk+eps);
            
        end
    end
    
end

    function [ang,len]=fit_pca_line(xy)
        % fits lines
        [coeff,score,roots] = pca(xy);
        dirVect = coeff(:,1);
        meanX=mean(xy,1);
        t = [min(score(:,1))-.2, max(score(:,1))+.2];
        endpts = [meanX + t(1)*dirVect'; meanX + t(2)*dirVect'];
        difs=endpts(1,:)-endpts(2,:);
        slope=difs(2)/difs(1);
        
        ang=atan(slope);
        len=sqrt(sum(difs.^2));
    end

end
