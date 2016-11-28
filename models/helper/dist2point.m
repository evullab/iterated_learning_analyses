function [d dpoint]=dist2point(Q1,Q2,P,slope)
x1=Q1(1);
y1=Q1(2);
x2=Q2(1);
y2=Q2(2);
P=P';
x0=P(1);
y0=P(2);
if (x2-x1)*(x0-x1)+(y2-y1)*(y0-y1) >= 0
    if (x2-x1)*(x0-x2)+(y2-y1)*(y0-y2) <= 0 % P is between the lines
        d = abs((x2-x1)*(y0-y1)-(y2-y1)*(x0-x1))/sqrt((x2-x1)^2+(y2-y1)^2);
        base=[Q1 Q2]';
        shif=[d*cos(atan(-1/slope)) d*sin(atan(-1/slope))]';
        dtest=[-shif+P shif+P [shif(1); -shif(2)]+P [-shif(1); shif(2)]+P]';
        min_d=inf; % Some floating point errors I think
        for dti=1:4
            if min(eig(cov([base;dtest(dti,:)])))<min_d
                dpoint=dtest(dti,:)';
                min_d=min(eig(cov([base;dtest(dti,:)])));
            end
        end
    else % P is outside on the Q2 side
        d = sqrt((x0-x2)^2+(y0-y2)^2);
        dpoint=Q2;
    end
else % P is outside on the Q1 side
    d = sqrt((x0-x1)^2+(y0-y1)^2);
    dpoint=Q1;
end
end