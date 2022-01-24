function imgs = MFMparse(data,corners,offset,planes,intscorrect,numplanes)
intscorrect = intscorrect(numplanes);
w = corners(2,2) - corners(1,2);
h = w;
imgs = uint16(zeros(h,w,planes));
for b = 1:size(corners,1)
        %imgs(:,:,b) = (data(corners(b,1):(corners(b,1)+w-1),corners(b,2):(corners(b,2)+w-1),:)-offset)/(intscorrect(b)/mean(intscorrect));
        imgs(:,:,b) = data(corners(b,1):(corners(b,1)+w-1),corners(b,2):(corners(b,2)+w-1),:)/(intscorrect(b)/mean(intscorrect))-offset./(intscorrect(b)/mean(intscorrect));
end