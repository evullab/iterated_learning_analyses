function plot_compare_line_prop(subj_data,mod_data,mod_params)

cc=linspecer(1);

num_mod=length(mod_data);

subj_line_prop=squeeze(mean(subj_data,2));

subj_mean=nanmean(subj_line_prop);
subj_sem=nanstd(subj_line_prop)./sqrt(sum(~isnan(subj_line_prop)));


figure('Position', [100, 100, num_mod*500, 500]);
set(gcf,'color','w');

for im = 1:num_mod
    curr_data=mod_data{im};

    mod_disp=squeeze(mean(curr_data,2));

    mod_mean=nanmean(mod_disp);
    mod_sem=nanstd(mod_disp)./sqrt(sum(~isnan(mod_disp)));

    subplot(1,num_mod,im)
    hold on
    
    plot(0:.1:1,0:.1:1,'--','Color',[.66,.66,.66])
    plot(mod_mean,subj_mean,'.','Color',cc,'MarkerEdgeColor',cc,...
                       'MarkerFaceColor',cc,...
                       'MarkerSize',30,'LineWidth',4)
    errbar(mod_mean,subj_mean,subj_sem,'Color',cc,'MarkerEdgeColor',cc,...
                       'MarkerFaceColor',cc,...
                       'LineWidth',4)
                   
    
    if 1==im
        hYLabel=ylabel('Subject');
    else
        hYLabel=ylabel('');
    end
    
    hXLabel=xlabel(mod_params{im}(1).fname);
    
    xlim([0,.35])
    ylim([0,.35])
    set(gca,'YTick',[0,.15,.3])
    set(gca,'XTick',[0,.15,.3])
    
    prettyplot(hXLabel,hYLabel,nan)
    
    % fine tuning after pretty plot
    set( gca, 'FontName'   , 'Helvetica','FontSize',25 );
    if ceil(num_mod/2)==im
        title( 'Line Proportion','FontSize',40,'Color',[.3 .3 .3])
    end
    set([hXLabel hYLabel]  , 'FontSize'   , 30          );
    set(gca,'XGrid','on')
    
    hold off
    
end

