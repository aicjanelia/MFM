function data = mfmzinterp2(dataorig,fitparamsr,fitparamsg,zstepsizeg,zstepsizer)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin<5
    zstepsizer = 100;
end

if nargin<4
    zstepsizeg = 100;
end

h = size(dataorig,1);
w = size(dataorig,2);
time = size(dataorig,4);

numpartsg = length(fitparamsg);
for a = 1:numpartsg
    zposg1(:,a) = fitparamsg{a}(:,2); %#ok<AGROW>
end
zposg = mean(zposg1,2)*zstepsizeg;

numpartsr = length(fitparamsr);
for a = 1:numpartsr
    zposr1(:,a) = fitparamsr{a}(:,2); %#ok<AGROW>
end
zposr = mean(zposr1,2)*zstepsizer;

%if min(zposr)>min(zposg)
%    error('Cannot interpolate, green channel lies outside red channel range');
%end

%if max(zposr)<max(zposg)
%    error('Cannot interpolate, green channel lies outside red channel range');
%end

data = zeros(size(dataorig));

for a = 1:time
    disp(['Z-interpolating frame ' num2str(a) ' of ' num2str(time)]);
    [x,y,z] = ndgrid(1:h,1:w,zposr);
    [xq,yq,zq] = ndgrid(1:h,1:w,zposg);
    data(:,:,:,a) = interpn(x,y,z,double(dataorig(:,:,:,a)),xq,yq,zq,'makima');
end
    
data = uint16(data);

end

