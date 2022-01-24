function [fitresult,resnorm,exitflag] = fit2dgauss(cutout,xlist,ylist)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
zdata = cutout(:);
zdata = zdata - min(zdata);
xydata = [xlist ylist];
[amp, ind] = max(zdata); % amp is the amplitude.
xo = xlist(ind); % guess that it is at the maximum
yo = ylist(ind); % guess that it is at the maximum
lower = [0 min(xlist) 0.01 min(ylist) 0.01];
upper = [inf max(xlist) 10 max(ylist) 10];
startpoint = [amp xo 1 yo 1];
[fitresult,resnorm,~,exitflag] = lsqcurvefit(@gaussian2d,startpoint,xydata,zdata,lower,upper);