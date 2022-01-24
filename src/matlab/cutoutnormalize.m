function cutoutnorm = cutoutnormalize(cutout)
planes = size(cutout,3);
cols = size(cutout,2);
rows = size(cutout,1);
cutout2 = zeros(rows*planes,cols);
for b = 1:planes
    rowstart = (b-1)*rows + 1;
    rowend = rowstart + rows - 1;
    cutout2(rowstart:rowend,:) = cutout(:,:,b);
end
cutoutnorm = cutout2 - min(min(cutout2));
%cutoutnorm = cutout3/max(max(cutout3));

