function analyze_iteration_dist(mem_data,exp_params)

correct=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts);

num_samp=10;
rand_distr=nan(exp_params.numDisp,exp_params.numChains,exp_params.numIts,num_samp);

for id=1:exp_params.numDisp
    disp(strcat('disp',num2str(id)))
    for ic=1:exp_params.numChains
        disp(strcat('chain',num2str(ic)))
        init_ind=mem_data.Chain==ic & mem_data.Seed==id & mem_data.Iter==1;
        init_data=mem_data(init_ind,:);
        init_xy=[init_data.x,init_data.y];
        
        for ii=2:exp_params.numIts
            
            sel_ind=mem_data.Chain==ic & mem_data.Seed==id & mem_data.Iter==ii;
            curr_data=mem_data(sel_ind,:);
            curr_xy=[curr_data.x,curr_data.y];
            map_xy=Hungarian_2d(init_xy,curr_xy);
            correct(id,ic,ii)=log10(mean(sqrt(sum((init_xy-map_xy).^2,2))));
            
            for is=1:num_samp
                sel_ind=mem_data.Chain==randsample(1:exp_params.numChains,1) & mem_data.Seed==randsample(1:exp_params.numChains,1) & mem_data.Iter==ii;
                rand_data=mem_data(sel_ind,:);
                rand_xy=[rand_data.x,rand_data.y];
                map_xy=Hungarian_2d(init_xy,rand_xy);
                rand_distr(id,ic,ii,is)=log10(mean(sqrt(sum((init_xy-map_xy).^2,2))));
            end
            
        end
    end
end
corr_sum=squeeze(mean(mean(correct,2),1));
corr_sum_sem=squeeze(std(mean(correct,2)))./sqrt(10);
rand_sum=squeeze(mean(mean(mean(rand_distr,4),2),1));
rand_sum_sem=squeeze(std(mean(mean(rand_distr,4),2)))./sqrt(10);

cc=linspecer(2);

figure('Position', [100, 100, 900, 600]);
set(gcf,'color','w');
hold on

h1=plot(-2,-2,'color',cc(1,:),'DisplayName','Correct');
h2=plot(-2,-2,'color',cc(2,:),'DisplayName','Random');
% shadedErrorBar(1:exp_params.numIts,corr_sum, ...
%     corr_sum_sem, ...
%     {'-','color',cc(1,:)});
% 
% shadedErrorBar(1:exp_params.numIts,rand_sum, ...
%     rand_sum_sem, ...
%     {'-','color',cc(2,:)});

errorbar(1:exp_params.numIts,corr_sum, ...
    corr_sum_sem, ...
    'color',cc(1,:),'linewidth',4);

errorbar(1:exp_params.numIts,rand_sum, ...
    rand_sum_sem, ...
    'color',cc(2,:),'linewidth',4);

% if exist('yt','var')
%     set(gca,'YTick',yt)
% end

set(gca,'YTick',[1.6,1.8,2.0,2.2])

hl=legend([h1,h2],'Correct','Random','Location','NorthWest');

hXLabel=xlabel('Iteration');
hYLabel=ylabel({'RMSE Distance','to Seed (Log10)'});
xlim([0,exp_params.numIts+1])
ylim([1.6,2.3])
prettyplot(hXLabel,hYLabel,nan)
hold off

end