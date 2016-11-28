function all_k=analyze_num_groups(all_mle,exp_params)
disp('Analyzing number of lines')
all_k=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts);
for id=1:exp_params.numDisp

    for ic=1:exp_params.numChains

        for ii=1:exp_params.numIts
            all_k(id,ic,ii)=all_mle{id,ic,ii}.k;
        end
    end
end

disp_k=squeeze(mean(all_k,2));
mean_k=squeeze(mean(disp_k));
sem_k=squeeze(std(disp_k,[],1))/sqrt(exp_params.numDisp);
disp(mean_k)
disp(sem_k)