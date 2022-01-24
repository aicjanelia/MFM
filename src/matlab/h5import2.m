function data = h5import2(pathname,filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
info = h5info(fullfile(pathname,filename));
dataset1 = info.Datasets(1).Name;
img1 = h5read(fullfile(pathname,filename),['/' dataset1]);
stacksize = size(img1);
clear img1;
numstacks = length(info.Datasets);
data = zeros([stacksize numstacks]);

for a = 1:numstacks
    disp(['Reading stack: ' num2str(a) ' of ' num2str(numstacks)]);
    data(:,:,:,a) = h5read(fullfile(pathname,filename),['/' info.Datasets(a).Name]);
end
    