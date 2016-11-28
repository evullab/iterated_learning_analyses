function curr_llk=calc_llk_sigma(param_fname,data,mle_samps,exp_params,mod_params,task_params)
% get log-likelihood of each recalled display given groupings and original
% targets

fname=fullfile(strcat(param_fname),strcat('sigma_llk',num2str(mod_params(1).sigma),'.mat'));

if ~exist(fname)
    
    curr_llk=nan(exp_params.numDisp,exp_params.numChains,(exp_params.numIts-1) );
    
    for id=1:exp_params.numDisp
        for ic=1:exp_params.numChains
            for ii=1:(exp_params.numIts-1)
                % Get objects and groupings
                curr_group=mle_samps{id,ic,ii};
                
                targ_sel=(data.Seed==id) & (data.Chain==ic) & (data.Iter==ii);
                targ_curr=data(targ_sel,:);
                targ_xy=[targ_curr.x targ_curr.y]+normrnd(0,.1,exp_params.numDots,2);
                
                guess_sel=(data.Seed==id) & (data.Chain==ic) & (data.Iter==(ii+1));
                guess_curr=data(guess_sel,:);
                guess_xy=[guess_curr.x guess_curr.y]+normrnd(0,.1,exp_params.numDots,2);
                
                
                % Calculate log likelihood
                ind_llk=distribution_response(targ_xy,curr_group,guess_xy,mod_params,task_params);
                curr_llk(id,ic,ii)=sum(ind_llk);
                
            end
        end
    end
    save(fname,'curr_llk');
else
    load(fname)
end


