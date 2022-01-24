function [tformg,tformr] = beadalign2(imgsg,imgsr,beadtrug,beadtrur,intscorrectg,intscorrectr,zmaxg,zmaxr)

numplanes = length(imgsg);
alignplane = ceil(numplanes/2);
forind = 1:numplanes;
fixedpoints = beadtrug{alignplane};
tformg = cell(numplanes,1);
tformr = cell(numplanes,1);
aveerrorg = zeros(numplanes,1);
aveerrorr = zeros(numplanes,1);
figure(98); 
figure(99); 
for a = forind
    movingpointsg = beadtrug{a};
    movingpointsr = beadtrur{a};
    tformg{a} = fitgeotrans(movingpointsg,fixedpoints,'affine');
    tformr{a} = fitgeotrans(movingpointsr,fixedpoints,'affine');
    newpointsg = transformPointsForward(tformg{a},movingpointsg);
    newpointsr = transformPointsForward(tformr{a},movingpointsr);
    aveerrorg(a) = mean(sqrt(sum((fixedpoints - newpointsg).^2,2)));
    aveerrorr(a) = mean(sqrt(sum((fixedpoints - newpointsr).^2,2)));
    sumimgfixed = imgsg{alignplane}(:,:,zmaxg{alignplane})./intscorrectg(alignplane);
    sumimgmovingg = imgsg{a}(:,:,zmaxg{a})./intscorrectg(a);
    sumimgmovingr = imgsr{a}(:,:,zmaxr{a})./intscorrectr(a);
    imgwarpg = imwarp(sumimgmovingg,tformg{a},'OutputView',imref2d(size(sumimgfixed)));
    imgwarpr = imwarp(sumimgmovingr,tformr{a},'OutputView',imref2d(size(sumimgfixed)));
    figure(98);
    subplot(sqrt(numplanes),sqrt(numplanes),a)
    imgfixed = bgsubtract(sumimgfixed,5);
    imgalignedg = bgsubtract(imgwarpg,5);
    imshowpair(imgfixed,imgalignedg,'ColorChannels',[1 2 0]); hold on
    axis('equal'); title(['Green Beads Average error = ' num2str(aveerrorg(a))]); 
    hold off; 
    figure(99);
    subplot(sqrt(numplanes),sqrt(numplanes),a)
    imgfixed = bgsubtract(sumimgfixed,5);
    imgalignedr = bgsubtract(imgwarpr,5);
    imshowpair(imgfixed,imgalignedr,'ColorChannels',[1 2 0]); hold on
    axis('equal'); title(['Red Beads Average error = ' num2str(aveerrorr(a))]); 
    hold off;
end
