function plot_compare_line_ang(subj_data,mod_data,mod_params,ci)

cc=linspecer(1);

num_mod=length(mod_data);

subj_line_ang=sum(sum(subj_data(:,:,1:2),3))./sum(sum(subj_data,3));

figure('Position', [100, 100, num_mod*500, 500]);
set(gcf,'color','w');

for im = 1:num_mod
    curr_data=mod_data{im};

    mod_disp=sum(sum(curr_data(:,:,1:2),3))./sum(sum(curr_data,3));


    subplot(1,num_mod,im)
    hold on
    
    plot(0:.1:1,0:.1:1,'--','Color',[.66,.66,.66])
    
    if ~exist('ci','var')
        plot(mod_disp,subj_line_ang,'.','Color',cc,'MarkerEdgeColor',cc,...
                           'MarkerFaceColor',cc,...
                           'MarkerSize',40,'LineWidth',4)
    else
        errorbar(mod_disp,subj_line_ang,abs(ci(1,:)-subj_line_ang),abs(ci(2,:)-subj_line_ang), ...
                            '.','Color',cc,'MarkerEdgeColor',cc,...
                           'MarkerFaceColor',cc,...
                           'MarkerSize',30,'LineWidth',4)
    end
    
    if 1==im
        hYLabel=ylabel('Subject');
    else
        hYLabel=ylabel('');
    end
    
    hXLabel=xlabel(mod_params{im}(1).fname);
    
    xlim([.1,.75])
    ylim([.1,.75])
    set(gca,'YTick',[.2,.4,.6])
    set(gca,'XTick',[.2,.4,.6])
    
    prettyplot(hXLabel,hYLabel,nan)
    
    % fine tuning after pretty plot
    set( gca, 'FontName'   , 'Helvetica','FontSize',25 );

    set(gcf,'NextPlot','add');
    axes;
    h = title('Proportion Similar Angles','FontSize',40,'Color',[.3 .3 .3]);
    set(gca,'Visible','off');
    set(h,'Visible','on');

    set([hXLabel hYLabel]  , 'FontSize'   , 30          );
    set(gca,'XGrid','on')
    
    hold off
    
end

