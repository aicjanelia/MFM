function peaks = peakfinder(img,radius,thresh,edg)

imgdil = imdilate(img,strel('disk',radius));
[peaksrawy,peaksrawx] = find(img == imgdil);
meanval = mean(mean(img));
thres = meanval*thresh;
intsraw = zeros(length(peaksrawx),1);
for a = 1:length(intsraw)
    intsraw(a) = img(peaksrawy(a),peaksrawx(a));
end
peaksreal = find(intsraw >= thres);
peaks = [peaksrawx(peaksreal) peaksrawy(peaksreal)];
[left,~] = find(peaks(:,1) <= edg); 
[right,~] = find(peaks(:,1) >= (size(img,2)-edg));
[top,~] = find(peaks(:,2) <= edg);
[bottom,~] = find(peaks(:,2) >= (size(img,1)-edg));
throw = unique([left;right;top;bottom]);
peaks(throw,:) = [];

%figure; imagesc(img); hold on; plot(peaks(:,1),peaks(:,2),'w+'); hold off














