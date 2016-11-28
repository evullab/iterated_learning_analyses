function plot_sequential(fname,yt)
% run analyze_sequential.R to generate csv

data=readtable(fname);

cc=linspecer(4);

conds={'Correct','Random seed','Random chain','Random order'};
correct=data(strcmp(data.match,'Correct'),:);
rand_seed=data(strcmp(data.match,'Random seed'),:);
rand_chain=data(strcmp(data.match,'Random chain'),:);
rand_order=data(strcmp(data.match,'Random order'),:);

all_data={correct,rand_seed,rand_chain,rand_order};

figure('Position', [100, 100, 900, 600]);
set(gcf,'color','w');
hold on

temp=[];
for ic=1:length(all_data)
    a=plot(all_data{ic}.n_back,all_data{ic}.mRMSE,'LineWidth',6,'Color',cc(ic,:),'DisplayName',conds{ic});
    temp=[temp a];
    errbar(all_data{ic}.n_back,all_data{ic}.mRMSE, ...
        all_data{ic}.sRMSE, ...
        'LineWidth',6,'Color',cc(ic,:))
end


xlim([0,16])
ylim([1.5,2.25])
legend(temp,'Location','SouthEast')

if exist('yt','var')
    set(gca,'YTick',yt)
end

hXLabel=xlabel('n-back');
hYLabel=ylabel({'Distance from Initial','Seed (log_{10} RMSE)'});

prettyplot(hXLabel,hYLabel,nan)
hold off