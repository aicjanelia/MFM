function [data,metadata] = nd2channelparse(filename,pathname,channel)

if nargin < 3
    channel = 0;
end

rawdata = bfopen(fullfile(pathname,filename));
data1 = rawdata{1};
omeMeta = rawdata{4};
data2 = data1(:,1);
imgids = data1(:,2);
clear data1;
clear rawdata;
channelcount = omeMeta.getChannelCount(0);
zstep = str2num(char(omeMeta.getPixelsPhysicalSizeZ(0))); %#ok<ST2NM>
if channelcount < 2
    channel = 0;
end

if channel == 1
    txt = 'C=1/2';
    framekeep = [];
elseif channel == 2
    txt = 'C=2/2';
    framekeep = [];
elseif channel == 0
    framekeep = 1:length(data2);
end

ii = 0;
if channel
    for a = 1:length(data2)
        if contains(imgids{a},txt)
            ii = ii+1;
            framekeep(ii) = a; %#ok<AGROW>
        end
    end
end

data3 = data2(framekeep);
clear data2;
numframes = length(data3);
h = size(data3{1},1);
w = size(data3{1},2);
data = uint16(zeros(h,w,numframes));

for c = 1:numframes
    data(:,:,c) = data3{c};
end
clear data3

metadata = zeros(numframes,5);
for b = 1:numframes
    metadata(b,1) = b;
    try
        metadata(b,2) = double(omeMeta.getPlanePositionX(0,framekeep(b)-1));
    catch
    end
    
    try
        metadata(b,3) = double(omeMeta.getPlanePositionY(0,framekeep(b)-1));
    catch
    end
    
    try
        metadata(b,4) = str2double(char(omeMeta.getPlaneTheZ(0,framekeep(b)-1)))*zstep;
    catch
    end
    
    try
        metadata(b,5) = double(omeMeta.getPlaneDeltaT(0,framekeep(b)-1));
    catch
    end
end

    
    
    


        
        
        

