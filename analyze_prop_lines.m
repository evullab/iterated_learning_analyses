function prop_lines=analyze_prop_lines(all_mle,exp_params)
disp('Analyzing proportion of lines')

num_lines=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts);
num_groups=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts);
for id=1:exp_params.numDisp

    for ic=1:exp_params.numChains

        for ii=1:exp_params.numIts
            num_lines(id,ic,ii)=sum(strcmp({all_mle{id,ic,ii}.groups.type},'clusterLine'));
            num_groups(id,ic,ii)=length(all_mle{id,ic,ii}.groups);
        end
    end
end

prop_lines=num_lines./num_groups;

disp_lines=squeeze(mean(prop_lines,2));
mean_lines=squeeze(mean(disp_lines));
sem_lines=squeeze(std(disp_lines,[],1))/sqrt(exp_params.numDisp);
disp(mean_lines)
disp(sem_lines)