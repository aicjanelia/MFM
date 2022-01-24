function aligndata = MFMalign(imgs,tform,imgrefsize,numplanes)
aligndata = uint16(zeros(size(imgs)));
planes = size(imgs,3);
tform2 = tform(numplanes);
parfor c = 1:planes
    currplane = imgs(:,:,c);
    currtform = tform2{c};
    aligndata(:,:,c) = imwarp(currplane,currtform,'OutputView',imref2d(imgrefsize));
end
