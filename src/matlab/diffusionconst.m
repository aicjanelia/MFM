function [D,alpha] = diffusionconst(tracks,acqtime,gamma,anomolous,rsqthresh,fitfrac)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if gamma == 4 && anomolous
    ft = fittype('4*D*t^alpha','independent',{'t'},'coefficients',{'D','alpha'});
    fitops = fitoptions('Method','NonlinearLeastSquares','StartPoint',[1 1],'Lower',[0 0],'Upper',[inf inf]);
    
elseif gamma == 4 && ~anomolous
    ft = fittype('4*D*t','independent',{'t'},'coefficients',{'D'});
    fitops = fitoptions('Method','NonlinearLeastSquares','StartPoint',1,'Lower',0,'Upper',inf);

elseif gamma == 6 && anomolous
    ft = fittype('6*D*t^alpha','independent',{'t'},'coefficients',{'D','alpha'});
    fitops = fitoptions('Method','NonlinearLeastSquares','StartPoint',[1 1],'Lower',[0 0],'Upper',[inf inf]);
    
elseif gamma == 6 && ~anomolous
    ft = fittype('6*D*t','independent',{'t'},'coefficients',{'D'});
    fitops = fitoptions('Method','NonlinearLeastSquares','StartPoint',1,'Lower',0,'Upper',inf);
else
    error('gamma or anomolous not set')
end

numtracks = length(tracks);
D = zeros(numtracks,1);
alpha = zeros(numtracks,1);

for a = 1:numtracks
   disp(a)
   currtrack = tracks{a};
   timepoints = size(currtrack,1);
   t = (1:(timepoints-1))*acqtime;
   distlist = (pdist(currtrack(:,1:3))/1000).^2;
   deltt = diff(combnk(1:timepoints,2),1,2);
   MSD = zeros(size(timepoints,1),1);
   for b = 1:(timepoints-1)
       MSD(b) = mean(distlist(deltt == b));
   end
   fitpoints = ceil(length(t)*fitfrac);
   if fitpoints >= 2
       [fm,gof] = fit(t(1:fitpoints)',MSD(1:fitpoints)',ft,fitops);
       coeffs = coeffvalues(fm);
       disp(gof.adjrsquare);
       if anomolous
           if gof.adjrsquare >= rsqthresh
               D(a) = coeffs(1);
               alpha(a) = coeffs(2);
           else
               D(a) = -inf;
               alpha(a) = -inf;
           end
       else
           if gof.adjrsquare >= rsqthresh
               D(a) = coeffs(1);
           else
               D(a) = -inf;
           end
       end
   else
       disp('Track too short to fit')
       if anomolous
           D(a) = -inf;
           alpha(a) = -inf;
       else
           D(a) = -inf;
       end
   end
end