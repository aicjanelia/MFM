function psfs = psfviewer(imgs,beadtru,fitparams)

planes = length(imgs);
numsnaps = size(imgs{1},3);
numparticles = size(beadtru{1},1);
cutoutsize1 = 13;
cutoutsize2 = 12;
avebead = zeros(cutoutsize2,cutoutsize2,numsnaps,planes);
[xgrid,ygrid] = meshgrid(1:cutoutsize2,1:cutoutsize2);
xlist = xgrid(:); ylist = ygrid(:);
for a = 1:planes
    currplane = imgs{a};
    beadimg3 = zeros(cutoutsize2,cutoutsize2,numsnaps,numparticles);
    for b = 1:numparticles
        disp([a b]);
        beadlocs = beadtru{a};
        peakx = round(beadlocs(b,1));
        peaky = round(beadlocs(b,2));
        xrange = (peakx-floor(cutoutsize1/2)):(peakx+floor(cutoutsize1/2));
        yrange = (peaky-floor(cutoutsize1/2)):(peaky+floor(cutoutsize1/2));
        beadimg = currplane(yrange,xrange,:);
        maxind = find(beadimg == max(beadimg(:)),1);
        [y,x,z] = ind2sub(size(beadimg),maxind);
        top = beadimg(y-1,x,z);
        bottom = beadimg(y+1,x,z);
        left = beadimg(y,x-1,z);
        right = beadimg(y,x+1,z);
        if left >= right
            xstart2 = (peakx + (x - (floor(cutoutsize2/2))-1)) - (floor(cutoutsize2/2));
            xend2 = (peakx + (x - (floor(cutoutsize2/2))-1)) + (floor(cutoutsize2/2)-1);
        elseif right > left
            xstart2 = (peakx + (x - (floor(cutoutsize2/2))-1)) - (floor(cutoutsize2/2)-1);
            xend2 = (peakx + (x - (floor(cutoutsize2/2))-1)) + (floor(cutoutsize2/2));
        end

        if top <= bottom
            ystart2 = (peaky + (y - (floor(cutoutsize2/2))-1)) - (floor(cutoutsize2/2)-1);
            yend2 = (peaky + (y - (floor(cutoutsize2/2))-1)) + (floor(cutoutsize2/2));
        elseif bottom < top
            ystart2 = (peaky + (y - (floor(cutoutsize2/2))-1)) - (floor(cutoutsize2/2));
            yend2 = (peaky + (y - (floor(cutoutsize2/2))-1)) + (floor(cutoutsize2/2)-1);
        end 
        beadimg2 = double(currplane(ystart2:yend2,xstart2:xend2,:));
        [xloc,yloc] = psffitgauss(beadimg2(:,:,z),0.5,xlist,ylist);
        xloc = xloc - mean(1:cutoutsize2);
        yloc = yloc - mean(1:cutoutsize2);
        xshift = -xloc; yshift = -yloc;
        beadimg3(:,:,:,b) = beadcenter(beadimg2,xshift,yshift);
    end
    avebead(:,:,:,a) = mean(beadimg3,4);
end

minzlist = zeros(numparticles,1);
maxzlist = zeros(numparticles,1);
for c = 1:length(fitparams)
    minzlist(c) = min(fitparams{c}(:,2));
    maxzlist(c) = max(fitparams{c}(:,2));
end

minz = round(mean(minzlist))-5;
maxz = round(mean(maxzlist))+5;
avebead2 = avebead(:,:,minz:maxz,:);
numsnaps2 = size(avebead2,3);
psfs = zeros(cutoutsize2*planes,cutoutsize2,numsnaps2);

for d = 1:numsnaps2
    currsnap = squeeze(avebead2(:,:,d,:));
    currsnap2 = bgsubtract(currsnap,5);
    psfs(:,:,d) = cutoutnormalize(currsnap2);
end

figure;
for f = 1:planes
    currpsf = avebead2(:,:,:,f);
    xyprofile = sum(currpsf,3);
    subplot(sqrt(planes),sqrt(planes),f)
    imagesc(xyprofile); axis('equal'); axis('image'); axis('off');
    colormap('gray')
end

figure;
for f = 1:planes
    currpsf = avebead2(:,:,:,f);
    xzprofile = (squeeze(sum(currpsf,1)))';
    subplot(sqrt(planes),sqrt(planes),f)
    imagesc(xzprofile); axis('equal'); axis('image'); axis('off');
    colormap('gray')
end

figure;
for f = 1:planes
    currpsf = avebead2(:,:,:,f);
    yzprofile = (squeeze(sum(currpsf,2)))';
    subplot(sqrt(planes),sqrt(planes),f)
    imagesc(yzprofile); axis('equal'); axis('image'); axis('off');
    colormap('gray')
end


    
    
    
    
    

    
        
        
        