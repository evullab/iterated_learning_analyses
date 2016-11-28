function coord=lineCenter(xy)
minX=min(xy(:,1));
minY=min(xy(:,2));
maxX=max(xy(:,1));
maxY=max(xy(:,2));
coord=[minX+maxX;minY+maxY]/2;