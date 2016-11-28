function plot_err_corr(same_err_corr,diff_err_corr,yt)

cc=linspecer(4);

same_err_corr2=squeeze(nanmean(same_err_corr,2));
diff_err_corr2=squeeze(nanmean(diff_err_corr,2));
difference=same_err_corr2-diff_err_corr2;

figure('Position', [100, 100, 900, 600]);
set(gcf,'color','w');
hold on

temp=[];
a=plot(1:19,mean(same_err_corr2),'LineWidth',6,'Color',cc(1,:),'DisplayName','Same Group');
temp=[temp a];
errbar(1:19,mean(same_err_corr2), ...
    std(same_err_corr2)./sqrt(10), ...
    'LineWidth',6,'Color',cc(1,:))

sec=squeeze(mean(same_err_corr2,2));
plot(-1,mean(sec),'.','MarkerSize',30,'Color',cc(1,:))
errbar(-1,mean(sec), ...
    std(sec)./sqrt(length(sec)), ...
    'LineWidth',6,'Color',cc(1,:))


a=plot(1:19,mean(diff_err_corr2),'LineWidth',6,'Color',cc(2,:),'DisplayName','Different Group');
temp=[temp a];
errbar(1:19,mean(diff_err_corr2), ...
    std(diff_err_corr2)./sqrt(10), ...
    'LineWidth',6,'Color',cc(2,:))

dec=squeeze(mean(diff_err_corr2,2));
plot(-1.1,mean(dec),'.','MarkerSize',30,'Color',cc(2,:))
errbar(-1.1,mean(dec), ...
    std(dec)./sqrt(length(dec)), ...
    'LineWidth',6,'Color',cc(2,:))

% a=plot(1:19,mean(difference),'LineWidth',6,'Color',[.3,.3,.3],'DisplayName','Difference');
% temp=[temp a];
% errbar(1:19,mean(difference), ...
%     std(difference)./sqrt(10), ...
%     'LineWidth',6,'Color',[.3,.3,.3])
% 
% dif=squeeze(mean(difference,2));
% plot(-.9,mean(dif),'.','MarkerSize',30,'Color',[.3,.3,.3])
% errbar(-.9,mean(dif), ...
%     std(dif)./sqrt(length(dif)), ...
%     'LineWidth',6,'Color',[.3,.3,.3])

legend(temp,'Location','NorthWest')

if exist('yt','var')
    set(gca,'YTick',yt)
end

set(gca,'XTick',[-1,5,10,15,20],'XTickLabel',{'Mean','5','10','15','20'})

xlim([-1.5,20])
ylim([0,.6])
hXLabel=xlabel('Iteration');
hYLabel=ylabel({'Translational','Error Similarity'});

prettyplot(hXLabel,hYLabel,nan)
hold off