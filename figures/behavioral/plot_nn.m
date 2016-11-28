function plot_nn(fname,yt)
% run analyze_spatial_structure.R to generate csv


data=readtable(fname);

cc=linspecer(1);

figure('Position', [100, 100, 900, 600]);
set(gcf,'color','w');
hold on


plot(data.Iter,data.m,'LineWidth',6,'Color',cc(1,:));
errbar(data.Iter,data.m, ...
    data.s./sqrt(10), ...
    'LineWidth',6,'Color',cc(1,:))



xlim([0,21])
% ylim([1.5,2.25])
% legend(temp,'Location','SouthEast')

if exist('yt','var')
    set(gca,'YTick',yt)
end

hXLabel=xlabel('Iteration');
hYLabel=ylabel({'Nearest Neighbor Ratio'});

prettyplot(hXLabel,hYLabel,nan)
hold off