function group_dispersion=analyze_dispersion_groups(all_mle,exp_params)
disp('Analyzing dispersion of groups')

group_dispersion=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts);

for id=1:exp_params.numDisp

    for ic=1:exp_params.numChains

        for ii=1:exp_params.numIts
            
            ind_dispersions={all_mle{id,ic,ii}.groups.cov};
            mean_dispersions=[];
            for ind_d=ind_dispersions
                mean_dispersions=[mean_dispersions; log10(det(ind_d{1}))];
            end
            group_dispersion(id,ic,ii)=mean(mean_dispersions);
        end
    end
end


disp_dispersion=squeeze(mean(group_dispersion,2));
mean_dispersion=squeeze(mean(disp_dispersion));
sem_dispersion=squeeze(std(disp_dispersion,[],1))/sqrt(exp_params.numDisp);
disp(mean_dispersion)
disp(sem_dispersion)