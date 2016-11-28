function plot_compare_dispersion(subj_data,mod_data,mod_params)

cc=linspecer(1);

num_mod=length(mod_data);

subj_disp=squeeze(mean(subj_data,2));

subj_mean=nanmean(subj_disp);
subj_sem=nanstd(subj_disp)./sqrt(sum(~isnan(subj_disp)));


figure('Position', [100, 100, num_mod*500, 500]);
set(gcf,'color','w');

for im = 1:num_mod
    curr_data=mod_data{im};

    mod_disp=squeeze(mean(curr_data,2));

    mod_mean=nanmean(mod_disp);
    mod_sem=nanstd(mod_disp)./sqrt(sum(~isnan(mod_disp)));

    subplot(1,num_mod,im)
    hold on
    
    plot(4:.1:6.5,4:.1:6.5,'--','Color',[.66,.66,.66])
    
    plot(mod_mean,subj_mean,'.','Color',cc,'MarkerEdgeColor',cc,...
                       'MarkerFaceColor',cc,...
                       'MarkerSize',30,'LineWidth',4)
    errbar(mod_mean,subj_mean,subj_sem,'Color',cc,'MarkerEdgeColor',cc,...
                       'MarkerFaceColor',cc,...
                       'LineWidth',4)
                   
    
    hXLabel=xlabel(mod_params{im}(1).fname);

    if 1==im
        hYLabel=ylabel('Subject');
    else
        hYLabel=ylabel('');
    end
    
    
    xlim([4,6.5])
    ylim([4,6.5])
    set(gca,'YTick',[4,5,6])
    set(gca,'XTick',[4,5,6])
    
    prettyplot(hXLabel,hYLabel,nan)
    
    if ceil(num_mod/2)==im
        title( {'Log Covariance','Determinant'},'FontSize',40,'Color',[.3 .3 .3])
    end
    
    set([hXLabel hYLabel]  , 'FontSize'   , 40          );
    set(gca,'XGrid','on')
    hold off
    
end

