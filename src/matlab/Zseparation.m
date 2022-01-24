function [d,intscorrect,fitparams] = Zseparation(imgs,beads,zstepsize)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

planes = length(imgs);
numbeads = length(beads{1});
zsteps = size(imgs{1},3);
zprofiles = cell(9,1);

for a = 1:numbeads
    sumint = zeros(zsteps,planes);
    for b = 1:planes
        center = beads{b}(a,:);
        cutout = imgs{b}(center(2),center(1),:);
        sumint(:,b) = squeeze(cutout);
    end
    zprofiles{a} = sumint;
end

fitparams = cell(numbeads,1);
for a = 1:numbeads
    currbead = zprofiles{a};
    for b = 1:planes
        profile = currbead(:,b);
        profilen = profile - min(profile);
        [a0,b0] = max(profilen);
        c0 = 10;
        options = fitoptions('gauss1','StartPoint',[a0 b0 c0]);
        [fo,gof] = fit((1:zsteps)',profilen,'gauss1',options);
        if gof.rsquare < 0.7
            warning(['Z-profile fit not good: bead ' num2str(a) ', plane ' num2str(b)])
        end
        fitparams{a}(b,:) = coeffvalues(fo);
    end
end

dlist = zeros(numbeads,1);
ints = zeros(planes,numbeads);
for c = 1:numbeads
    beadlocs = fitparams{c}(:,2);
    ints(:,c) = fitparams{c}(:,1);
    [fo2, gof2] = fit((1:planes)',beadlocs,'poly1');
    if gof2.rsquare < 0.7
        warning(['Plane step size fit not good:  bead ' num2str(c)])
    end
    coeffs = coeffvalues(fo2);
    dlist(c) = coeffs(1);
end
d = mean(dlist)*zstepsize;

intsn = zeros(planes,numbeads);
for a = 1:numbeads
    intsn(:,a) = ints(:,a)/max(ints(:,a));
end
intsnn = mean(intsn,2);
intscorrect = intsnn/max(intsnn);

%display peak z-pos for each plane
fittedbeadlocs = feval(fo2,1:planes)*zstepsize;
figure; plot((1:planes),beadlocs*zstepsize,'.'); hold on
plot(1:planes,fittedbeadlocs,'r'); hold off
xlabel('Plane'); ylabel('Relative Focal Position (nm)');
title(['Fit R^2 = ' num2str(gof2.rsquare)]);

    
    



