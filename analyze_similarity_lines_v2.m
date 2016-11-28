function analyze_similarity_lines_v2(all_mle,exp_params)
% analyze_similarity_lines_v2-Using actual values instead of proportions?
disp('Analyzing similarity of lines')

%% Partition data into quantiles
[all_ang_sim,all_len_sim,ang_sim,len_sim]=get_similarity_lines(all_mle,exp_params);

%% Plot

ang_sim_final=zeros(size(ang_sim,1),size(ang_sim,2),size(ang_sim,3));
len_sim_final=zeros(size(len_sim,1),size(len_sim,2),size(len_sim,3));
for id=1:exp_params.numDisp
    for ic=1:exp_params.numChains
        for ii=1:exp_params.numIts

            ang_sim_final(id,ic,ii)=mean(ang_sim{id,ic,ii});
            len_sim_final(id,ic,ii)=mean(len_sim{id,ic,ii});

        end
    end
end

disp_ang_sim=squeeze(nanmean(ang_sim_final,2));
disp_len_sim=squeeze(nanmean(len_sim_final,2));

% Smoothing
window_ang_sim=nan(exp_params.numDisp,exp_params.numIts-2);
window_len_sim=nan(exp_params.numDisp,exp_params.numIts-2);
for ii=2:(exp_params.numIts-1)
    window_ang_sim(:,ii-1,:)=nanmean(disp_ang_sim(:,ii-1:ii+1,:),2);
    window_len_sim(:,ii-1,:)=nanmean(disp_len_sim(:,ii-1:ii+1,:),2);
end


mean_ang_sim=squeeze(nanmean(window_ang_sim));
sem_ang_sim=squeeze(nanstd(window_ang_sim,[],1))./sqrt(sum(~isnan(window_ang_sim)));
disp('Angle similarity')
disp(mean_ang_sim)
disp(sem_ang_sim)

mean_len_sim=squeeze(nanmean(window_len_sim));
sem_len_sim=squeeze(nanstd(window_len_sim,[],1))./sqrt(sum(~isnan(window_len_sim)));
disp('Length similarity')
disp(mean_len_sim)
disp(sem_len_sim)

disp('Pass these through an lmer in R so we can account for the random effects of chain and display')
