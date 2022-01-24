function [beads,imgs,zstepsize,zmax] = beadfinder2(planes,thresh,edg,filename,pathname,flip,channel)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
offset = 100;

%error catch
if sqrt(planes) ~= round(sqrt(planes))
    error('Number of planes must be the square of an integer')
end

%read data and compute where to segment 
%[data,metadata] = readnd22(filename,pathname);
[data,metadata] = nd2channelparse(filename,pathname,channel);
if flip
    data = fliplr(data);
end
zstepsize = abs(mean(diff(metadata(:,4))))*1000;
if zstepsize == 0
    zstepsize = input('Z-step size cannot be found.  Input Z-step size in nm: ');
end
chip = 512;
rowcol = sqrt(planes);
imgsize = floor(chip/rowcol);
cuts = zeros(rowcol,1);
for a = 1:rowcol
    cuts(a) = (a-1)*imgsize+1;
end
[xcuts,ycuts] = ndgrid(cuts,cuts);
corners = fliplr([xcuts(:) ycuts(:)]);
imgs = cell(1,planes);
imgbg = cell(1,planes);
centers = cell(1,planes);
zmax = cell(1,planes);

%segment data by plane, and find bead locations in each
for b = 1:size(corners,1)
    imgs{b} = data(corners(b,1):(corners(b,1)+imgsize-1),corners(b,2):(corners(b,2)+imgsize-1),:)-offset;
    currimg = imgs{b}; 
    maxind = find(currimg == max(currimg(:)));
    maxind = maxind(1);
    [~,~,zmax{b}] = ind2sub(size(currimg),maxind);
    imgbg{b} = bgsubtract(currimg,5);
    radius = 3;
    centers{b} = peakfinder(imgbg{b}(:,:,zmax{b}),radius,thresh,edg);
end

%set up so images are aligned to middle plae
midplane = ceil(planes/2);
centersoffset = zeros(planes,2);
forind = [(midplane-1):-1:1 (midplane+1):planes];

%rough align using cross-correlation
for c = forind
    if c < midplane
        inc = 1;
    elseif c > midplane
        inc = -1;
    end
    template = imgbg{c}(edg:(end-edg),edg:(end-edg),zmax{c}); imgalign = imgbg{c+inc}(edg:(end-edg),edg:(end-edg),zmax{c+inc});
    cfun = normxcorr2(template,imgalign);
    [~, imax] = max(abs(cfun(:)));
    [ypeak, xpeak] = ind2sub(size(cfun),imax(1));
    offset = zeros(planes,2);
    if c < midplane
        replength = length(c:-inc:1);
        offset(c:-inc:1,:) = repmat([(xpeak-size(template,2)) (ypeak-size(template,1))],replength,1);
    elseif c > midplane
        replength = length(c:-inc:planes);
        offset(c:-inc:planes,:) = repmat([(xpeak-size(template,2)) (ypeak-size(template,1))],replength,1);
    end
    centersoffset = centersoffset+offset;
end

%offset bead locations to rough alignment
newcenters = cell(1,planes);
numbeads = zeros(planes,1);
newbeadlocs = [0 0];
for d = 1:planes
    newcenters{d}(:,1) = centers{d}(:,1) + centersoffset(d,1);
    newcenters{d}(:,2) = centers{d}(:,2) + centersoffset(d,2);
    numbeads(d) = length(newcenters{d});
    newbeadlocs = [newbeadlocs; newcenters{d}]; %#ok<AGROW>  
end

%use k-means clustering to find corresponding beads in each channel
newbeadlocs(1,:) = [];
seedplane = find(numbeads == max(numbeads));
seedplane = seedplane(abs(midplane-seedplane) == min(abs(midplane-seedplane)));
seedplane = min(seedplane);
k = max(numbeads);
indx = kmeans(newbeadlocs,k,'start',newcenters{seedplane});

%find only beads with indices that occur once per frame for all frames
planecutoffs = cumsum(numbeads);
goodbeads = [];
for f = 1:max(indx)
    beadindx = find(indx == f);
    if length(beadindx) == planes
        planelog = sum(beadindx <= planecutoffs);
        if planelog == planes
            goodbeads = [goodbeads; f]; %#ok<AGROW>
        end
    end
end

%find corresponding bead locations in raw data
goodbeadindx = zeros(length(goodbeads),planes);
for g = 1:length(goodbeads)
    goodbeadindx(g,:) = (find(indx == goodbeads(g)) - (planecutoffs - numbeads))';
end

beads = cell(planes,1);
figure;
for h = 1:planes
    beads{h} = centers{h}(goodbeadindx(:,h),:);
    subplot(rowcol,rowcol,h)
    imagesc(imgbg{h}(:,:,zmax{h})); hold on
    axis('equal'); axis('image'); axis('off');
    v = 0;
    for j = 1:length(beads{h})
        v = v+1;
        z = text(beads{h}(j,1),beads{h}(j,2),num2str(v));
        set(z,'Color',[1 1 1])
        %viscircles(beads{h},repmat(7,length(beads{h}),1));
    end
end    
end
  
    


