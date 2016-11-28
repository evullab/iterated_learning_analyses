function [window_ang_sim,window_len_sim]=analyze_similarity_lines_v3(all_mle,exp_params)
% analyze_similarity_lines_v3-Using counts instead of proportions?
disp('Analyzing similarity of lines')

%% Partition data into quantiles
[all_ang_sim,all_len_sim,ang_sim,len_sim]=get_similarity_lines(all_mle,exp_params);

%% Plot

all_ang_quant=partition2quantile(all_ang_sim,ang_sim,exp_params);
all_len_quant=partition2quantile(all_len_sim,len_sim,exp_params);

num_quants=4;
ang_sim_final=zeros(size(ang_sim,1),size(ang_sim,2),size(ang_sim,3),2); % median split
len_sim_final=zeros(size(len_sim,1),size(len_sim,2),size(len_sim,3),2);
for id=1:exp_params.numDisp
    for ic=1:exp_params.numChains
        for ii=1:exp_params.numIts
            for iq=1:num_quants
                if iq>2 % if lines are different
                    ang_sim_final(id,ic,ii,2)=ang_sim_final(id,ic,ii,2)+sum(iq==all_ang_quant{id,ic,ii});
                    len_sim_final(id,ic,ii,2)=len_sim_final(id,ic,ii,2)+sum(iq==all_len_quant{id,ic,ii});
                else % if lines are similar
                    ang_sim_final(id,ic,ii,1)=ang_sim_final(id,ic,ii,1)+sum(iq==all_ang_quant{id,ic,ii});
                    len_sim_final(id,ic,ii,1)=len_sim_final(id,ic,ii,1)+sum(iq==all_len_quant{id,ic,ii});
                end
            end
        end
    end
end

disp_ang_sim=squeeze(nanmean(ang_sim_final,2));
disp_len_sim=squeeze(nanmean(len_sim_final,2));

% Smoothing
window_ang_sim=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts-2);
window_len_sim=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts-2);
for ii=2:(exp_params.numIts-1)
    window_ang_sim(:,:,ii-1)=mean(ang_sim_final(:,:,ii-1:ii+1,1)-ang_sim_final(:,:,ii-1:ii+1,2),3);
    window_len_sim(:,:,ii-1)=mean(len_sim_final(:,:,ii-1:ii+1,1)-len_sim_final(:,:,ii-1:ii+1,2),3);
end

% 
% mean_ang_sim=squeeze(nanmean(window_ang_sim));
% sem_ang_sim=squeeze(nanstd(window_ang_sim,[],1))./squeeze(sqrt(sum(~isnan(window_ang_sim))));
% disp('Angle similarity')
% disp(mean_ang_sim')
% disp(sem_ang_sim')
% 
% mean_len_sim=squeeze(nanmean(window_len_sim));
% sem_len_sim=squeeze(nanstd(window_len_sim,[],1))./squeeze(sqrt(sum(~isnan(window_len_sim))));
% disp('Length similarity')
% disp(mean_len_sim')
% disp(sem_len_sim')
% 
% 
