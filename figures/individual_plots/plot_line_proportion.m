function plot_line_proportion(line_data,yt)

cc=linspecer(1);

figure('Position', [100, 100, 900, 600]);
set(gcf,'color','w');
hold on
mean_line_data=mean(line_data,2);

plot(1:size(mean_line_data,3),squeeze(mean(mean_line_data)),'LineWidth',6,'Color',cc)

errbar(1:size(mean_line_data,3),mean(mean_line_data), ...
    std(mean_line_data)./sqrt(size(mean_line_data,1)), ...
    'LineWidth',6,'Color',cc)

% errorbar(1:size(line_data,3),mean(mean_line_data), ...
%     std(mean_line_data)./sqrt(size(mean_line_data,1)), ...
%     'LineWidth',6,'Color',cc)

% shadedErrorBar(1:size(line_data,3),mean(mean_line_data), ...
%     std(mean_line_data)./sqrt(size(mean_line_data,1)), ...
%     {'-','color',cc})

if exist('yt','var')
    set(gca,'YTick',yt)
end

hXLabel=xlabel('Iteration');
hYLabel=ylabel('Proportion of Lines');
xlim([0,size(line_data,3)+1])
ylim([0,.31])
prettyplot(hXLabel,hYLabel,nan)
hold off

end