function [beadtru] = beadloc(imgs,beads,zmax)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

numplanes = length(beads);
ft = fittype('exp(-(((x-b1)/c1).^2 + ((y-b2)/c2).^2)) + d','dependent','z','independent',{'x' 'y'},'coefficients',{'b1' 'c1' 'b2' 'c2' 'd'});
options = fitoptions(ft);
options.Robust = 'Bisquare';
options.Algorithm = 'Trust-Region';
options.MaxFunEvals = 1e4;
options.MaxIter = 1e4;

beadtru = cell(numplanes,1);
for a = 1:numplanes
    currimg = imgs{a}(:,:,zmax{a});
    sumimg = sum(currimg,3);
    beadlocs = beads{a};
    numbeads = length(beadlocs);
    for b = 1:numbeads
        tic
        disp(['Localizing bead ' num2str(b) ' of ' num2str(numbeads) ' in plane ' num2str(a) ' of ' num2str(numplanes)]);  
        x = beadlocs(b,1); xv = (x-3):(x+3);
        y = beadlocs(b,2); yv = (y-3):(y+3);
        cutout = sumimg(yv,xv);
        cutoutn = cutout./(max(max(cutout)));
        cutoutnn = cutoutn - min(min(cutoutn));
        [b10,b20] = com(x,y,cutout);
        c10 = 1; c20 = 1;
        d0 = min(min(cutoutnn));
        options.StartPoint = [b10 c10 b20 c20 d0];
        [xg,yg] = meshgrid(xv,yv);
        xlist = reshape(xg,numel(xg),1);
        ylist = reshape(yg,numel(yg),1);
        zlist = reshape(cutoutnn,numel(cutoutnn),1);
        [fo, gof] = fit([xlist,ylist],zlist,ft,options);
        if gof.adjrsquare < 0.5
            warning(['Warning:  poor fit in plane ' num2str(a) ' bead ' num2str(b)]);
        end
        coeffs = coeffvalues(fo);
        xtru = coeffs(1); ytru = coeffs(3);
        beadtru{a}(b,:) = [xtru ytru];
        toc
    end
end