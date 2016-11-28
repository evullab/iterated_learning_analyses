function [window_ang_sim,window_len_sim]=analyze_similarity_lines(all_mle,exp_params)
disp('Analyzing similarity of lines')

%% Partition data into quantiles
[all_ang_sim,all_len_sim,ang_sim,len_sim]=get_similarity_lines(all_mle,exp_params);

all_ang_quant=partition2quantile(all_ang_sim,ang_sim,exp_params);
all_len_quant=partition2quantile(all_len_sim,len_sim,exp_params);

%% Plot
num_quants=4;
ang_sim_final=zeros(size(ang_sim,1),size(ang_sim,2),size(ang_sim,3),num_quants);
len_sim_final=zeros(size(len_sim,1),size(len_sim,2),size(len_sim,3),num_quants);
for id=1:exp_params.numDisp
    for ic=1:exp_params.numChains
        for ii=1:exp_params.numIts
            for iq=1:num_quants
                ang_sim_final(id,ic,ii,iq)=ang_sim_final(id,ic,ii,iq)+sum(iq==all_ang_quant{id,ic,ii});
                len_sim_final(id,ic,ii,iq)=len_sim_final(id,ic,ii,iq)+sum(iq==all_len_quant{id,ic,ii});
            end
        end
    end
end

disp_ang_sim=squeeze(nansum(ang_sim_final,2));
disp_len_sim=squeeze(nansum(len_sim_final,2));

% Smoothing
win_size=4;
window_ang_sim=nan(exp_params.numDisp,exp_params.numIts-win_size,num_quants);
window_len_sim=nan(exp_params.numDisp,exp_params.numIts-win_size,num_quants);
for ii=(win_size+1):exp_params.numIts
    window_ang_sim(:,ii-win_size,:)=nansum(disp_ang_sim(:,ii-win_size:ii,:),2);
    window_len_sim(:,ii-win_size,:)=nansum(disp_len_sim(:,ii-win_size:ii,:),2);
end


mean_ang_sim=squeeze(nanmean(window_ang_sim));
sem_ang_sim=squeeze(nanstd(window_ang_sim,[],1))/sqrt(exp_params.numDisp);
disp('Angle similarity')
disp(mean_ang_sim)
disp(sem_ang_sim)

mean_len_sim=squeeze(nanmean(window_len_sim));
sem_len_sim=squeeze(nanstd(window_len_sim,[],1))/sqrt(exp_params.numDisp);
disp('Length similarity')
disp(mean_len_sim)
disp(sem_len_sim)
