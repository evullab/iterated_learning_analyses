function plot_dispersion(dispersion_data,yt)

cc=linspecer(1);

figure('Position', [100, 100, 900, 600]);
set(gcf,'color','w');
hold on
mean_disp_data=mean(dispersion_data,2);

plot(1:size(dispersion_data,3),squeeze(mean(mean_disp_data)),'LineWidth',6,'Color',cc)

errbar(1:size(dispersion_data,3),mean(mean_disp_data), ...
    std(mean_disp_data)./sqrt(size(mean_disp_data,1)), ...
    'LineWidth',6,'Color',cc)

% shadedErrorBar(1:size(dispersion_data,3),mean(mean_disp_data), ...
%     std(mean_disp_data)./sqrt(size(mean_disp_data,1)), ...
%     {'-','color',cc})

if exist('yt','var')
    set(gca,'YTick',yt)
end

hXLabel=xlabel('Iteration');
hYLabel=ylabel({'Log Covariance','Determinant'});
xlim([0,size(dispersion_data,3)+1])
prettyplot(hXLabel,hYLabel,nan)
hold off

end