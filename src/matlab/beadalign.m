function tform = beadalign(imgs,beadtru,intscorrect,zmax)

numplanes = length(imgs);
alignplane = ceil(numplanes/2);
forind = 1:numplanes; forind(forind == alignplane) = [];
fixedpoints = beadtru{alignplane};
tform = cell(numplanes,1);
aveerror = zeros(numplanes,1);
figure;
for a = forind
    movingpoints = beadtru{a};
    tform{a} = fitgeotrans(movingpoints,fixedpoints,'affine');
    newpoints = transformPointsForward(tform{a},movingpoints);
    aveerror(a) = mean(sqrt(sum((fixedpoints - newpoints).^2,2)));
    sumimgfixed = imgs{alignplane}(:,:,zmax{alignplane})./intscorrect(alignplane);
    sumimgmoving = imgs{a}(:,:,zmax{a})./intscorrect(a);
    imgwarp = imwarp(sumimgmoving,tform{a},'OutputView',imref2d(size(sumimgfixed)));
    subplot(sqrt(numplanes),sqrt(numplanes),a)
    imgfixed = bgsubtract(sumimgfixed,5);
    imgaligned = bgsubtract(imgwarp,5);
    imshowpair(imgfixed,imgaligned,'ColorChannels',[1 2 0]); hold on
    axis('equal'); title(['Average error = ' num2str(aveerror(a))]); 
    hold off;
end

tform{alignplane} = affine2d();
    
    
    



