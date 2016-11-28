function plot_line_ang(ang_data,yt,ci)

cc=linspecer(1);
window_size=4;

figure('Position', [100, 100, 900, 600]);
set(gcf,'color','w');
hold on
mean_ang_data=sum(sum(ang_data(:,:,1:2),3))./sum(sum(ang_data,3));

if ~exist('ci','var')
    plot((window_size+1):size(ang_data,2)+window_size,mean_ang_data, ...
        'LineWidth',6,'Color',cc)
    xlim([window_size,size(ang_data,2)+window_size+1])
else
%     shadedErrorBar((window_size+1):size(ang_data,2)+window_size,mean_ang_data, ...
%         flipud(abs(ci+[-mean_ang_data;-mean_ang_data])), ...
%         {'-','color',cc})
    
    plot((window_size+1):size(ang_data,2)+window_size,mean_ang_data,'LineWidth',6,'Color',cc)

    errbar((window_size+1):size(ang_data,2)+window_size,mean_ang_data, ...
        abs(ci(2,:)+-mean_ang_data),abs(ci(1,:)+-mean_ang_data), ...
        'LineWidth',6,'Color',cc)
    
    xlim([window_size,size(ang_data,2)+window_size+1])
end

if exist('yt','var')
    set(gca,'YTick',yt)
end

hXLabel=xlabel('Iteration');
hYLabel=ylabel({'Proportion of Lines' , 'with Similar Angles'});

prettyplot(hXLabel,hYLabel,nan)
hold off

end