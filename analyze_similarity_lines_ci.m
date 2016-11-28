function [ang_prct,len_prct]=analyze_similarity_lines_ci(all_mle,exp_params)
% 11/23/2016-Generate CI by resampling, since number of iterations with
% pairs of lines too small for SEM

num_samp=1000;
win_size=4;

all_ang=nan(num_samp,exp_params.numIts-win_size);
all_len=nan(num_samp,exp_params.numIts-win_size);

[all_ang_sim,all_len_sim,ang_sim,len_sim]=get_similarity_lines(all_mle,exp_params);

all_ang_quant_orig=partition2quantile(all_ang_sim,ang_sim,exp_params);
all_len_quant_orig=partition2quantile(all_len_sim,len_sim,exp_params);

for is =1:num_samp

    %% Resample
    all_ang_quant=all_ang_quant_orig;
    all_len_quant=all_len_quant_orig;
    for ii =1:exp_params.numIts
        to_sample=randsample(1:100,100,true);
        for is2=1:100
            r_is2=to_sample(is2);
            all_ang_quant(ceil(is2/10),mod(is2,10)+1,ii)=all_ang_quant_orig(ceil(r_is2/10),mod(r_is2,10)+1,ii);
            all_len_quant(ceil(is2/10),mod(is2,10)+1,ii)=all_len_quant_orig(ceil(r_is2/10),mod(r_is2,10)+1,ii);
        end
        
    end
    %% Partition data into quantiles
    

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
    
    window_ang_sim=nan(exp_params.numDisp,exp_params.numIts-win_size,num_quants);
    window_len_sim=nan(exp_params.numDisp,exp_params.numIts-win_size,num_quants);
    for ii=(win_size+1):exp_params.numIts
        window_ang_sim(:,ii-win_size,:)=nansum(disp_ang_sim(:,ii-win_size:ii,:),2);
        window_len_sim(:,ii-win_size,:)=nansum(disp_len_sim(:,ii-win_size:ii,:),2);
    end
    
    mean_ang_data=sum(sum(window_ang_sim(:,:,1:2),3))./sum(sum(window_ang_sim,3));
    mean_len_data=sum(sum(window_len_sim(:,:,1:2),3))./sum(sum(window_len_sim,3));
    
    all_ang(is,:)=mean_ang_data;
    all_len(is,:)=mean_len_data;
end

ang_prct=[prctile(all_ang,2.5);prctile(all_ang,97.5)];
len_prct=[prctile(all_len,2.5);prctile(all_len,97.5)];


end
