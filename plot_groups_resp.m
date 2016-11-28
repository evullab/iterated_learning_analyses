function plot_groups_resp(xy,resp,group)

cc=linspecer(group.k);
figure();

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

plot(resp(:,1),resp(:,2),'.','MarkerSize',20,'Color','r')

circle(0,0,275)
xlim([-300 300])
ylim([-300 300])
axis square;
set(gca,'xtick',[])
set(gca,'ytick',[])
axis off;

hold off

end

% function plot_groups(xy,groups)
% cols=linspecer(groups.k);
% 
% figure;
% hold on;
% for g =1:groups.k
%     curr_targ=xy(groups.assign==g,:);
%     plot(curr_targ(:,1),curr_targ(:,2),'ok','MarkerFaceColor',cols(g,:),'MarkerEdgeColor',cols(g,:))
% end
% xlim([-275,275])
% ylim([-275,275])
% hold off