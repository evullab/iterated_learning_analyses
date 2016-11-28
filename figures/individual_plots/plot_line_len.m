function plot_line_len(len_data,yt,ci)

cc=linspecer(1);
window_size=4;

figure('Position', [100, 100, 900, 600]);
set(gcf,'color','w');
hold on
mean_len_data=sum(sum(len_data(:,:,1:2),3))./sum(sum(len_data,3));

if ~exist('ci','var')
    plot((window_size+1):size(len_data,2)+window_size,mean_len_data, ...
        'LineWidth',6,'Color',cc)
    xlim([window_size,size(ang_data,2)+window_size+1])
else
    shadedErrorBar((window_size+1):size(len_data,2)+window_size,mean_len_data, ...
        flipud(abs(ci+[-mean_len_data;-mean_len_data])), ...
        {'-','color',cc})
    xlim([window_size+1,size(len_data,2)+window_size])
end


if exist('yt','var')
    set(gca,'YTick',yt)
end

hXLabel=xlabel('Iteration');
hYLabel=ylabel({'Proportion of Lines' , 'with Similar Angles'});
prettyplot(hXLabel,hYLabel,nan)
hold off

end