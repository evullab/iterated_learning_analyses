function plot_grouping(fname,xy,group)

cc=linspecer(group.k);
if ~isnan(fname)
    figure('Visible','off');
    %figure;
else
    figure();
end
set(gcf,'color','w');
hold on

for ii=1:size(xy,1)
    filledCircle(xy(ii,:),10,30,cc(group.assign(ii)==[group.groups.id],:));
end

for cci=1:group.k
    
    curr_group=group.groups(cci);
    if strcmp(curr_group.type,'clusterLine')
        hfT1=curr_group.len/2;
        cB1=curr_group.ang;
        shift1=hfT1*[cos(atan(cB1)) sin(atan(cB1))]';
        Q11=shift1+curr_group.center;
        Q21=-shift1+curr_group.center;
        plot([Q11(1) Q21(1)],[Q11(2) Q21(2)],'Color',cc(cci,:))
    else
        if sum(group.assign==curr_group.id)>1
            h=error_ellipse(curr_group.cov,curr_group.mean);
            set(h,'Color',cc(cci,:))
        else
        end
    end
end



circle(0,0,275)
xlim([-300 300])
ylim([-300 300])
axis square;
set(gca,'xtick',[])
set(gca,'ytick',[])
axis off;

if ~isnan(fname)
    saveas(gcf,fname)
end
hold off

end