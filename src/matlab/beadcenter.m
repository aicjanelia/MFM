function beadimg3 = beadcenter(beadimg2,xshift,yshift)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

xcoord = 1:size(beadimg2,2);
ycoord = 1:size(beadimg2,1);
zcoord = 1:size(beadimg2,3);
xcoord2 = xcoord+xshift;
ycoord2 = ycoord+yshift;

[xgrid,ygrid,zgrid] = meshgrid(xcoord,ycoord,zcoord);
[xgrid2,ygrid2,zgrid2] = meshgrid(xcoord2,ycoord2,zcoord);

beadimg3 = interp3(xgrid,ygrid,zgrid,beadimg2,xgrid2,ygrid2,zgrid2,'spline');
end

