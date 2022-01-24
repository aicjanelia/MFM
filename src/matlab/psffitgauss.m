function [xloc,yloc,sx,sy,gof,flag] = psffitgauss(cutout,flagthresh,xlist,ylist)

cutoutmin = cutout - min(cutout(:));
cutoutn = cutoutmin/max(cutoutmin(:));
zlist = cutoutn(:);

comx = sum(sum(xlist.*zlist))/sum(sum(zlist));
comy = sum(sum(ylist.*zlist))/sum(sum(zlist));

ft = fittype('exp(-(((x-b1)/c1).^2 + ((y-b2)/c2).^2))','dependent','z','independent',{'x' 'y'},'coefficients',{'b1' 'c1' 'b2' 'c2'});
[fo, gof] = fit([xlist,ylist],zlist,ft,'StartPoint',[comx 1 comy 1],'Upper',[max(xlist) 5 max(ylist) 5],'Lower',[min(xlist) 0 min(ylist) 0],'Algorithm','Trust-Region',...
    'TolFun',1e-3,'TolX',1e-3);
coeffs = coeffvalues(fo);
xloc = coeffs(1); yloc = coeffs(3);
sx = coeffs(2); sy = coeffs(4);
flag = gof.adjrsquare < flagthresh;

