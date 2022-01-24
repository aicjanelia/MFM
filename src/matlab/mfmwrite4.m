function mfmwrite4(filename,pathname,intscorrect,tform,psfs,intcorrection,process,radius,numplanes,deconviter,zstepsize,d,patternlength,framekeep,suffix,flip,channel,zinterp,fitparamsr,fitparamsg,zstepsizeg,zstepsizer)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
try
    gcp;
catch
end
planes = length(numplanes);
offset = 110;
id = fullfile(pathname,filename);
disp('Retreiving File Information...');
r = bfGetReader(id);
disp('Done!')
frames = r.getImageCount;
if channel
    frames = frames/2;
end
numreps = frames/patternlength;
frameread = [];
for a = 0:(numreps-1)
    currframes = (a*patternlength)+framekeep;
    frameread = [frameread currframes]; %#ok<AGROW>
end
firstimg = bfGetPlane(r,1);
chip = size(firstimg,2);
rowcol = 3;
imgsize = floor(chip/rowcol);
cuts = zeros(rowcol,1);
for a = 1:rowcol
    cuts(a) = (a-1)*imgsize+1;
end
[xcuts,ycuts] = ndgrid(cuts,cuts);
corners = fliplr([xcuts(:) ycuts(:)]);
corners = corners(1:planes,:);
%omeMeta = r.getMetadataStore();
%metadata = zeros(length(frameread),5);
[~,filesave1] = fileparts(filename);
if channel == 1
    suffix = [suffix '_Ch1'];
elseif channel == 2
    suffix = [suffix '_Ch2'];
end
filesave2 = [filesave1 '_' suffix '.h5'];
filesave = filenamefix(filesave2);
w = corners(2,2) - corners(1,2);
h = w;
leadingzeros = floor(log10(length(frameread))) + 1;
midplane = numplanes == 5;
if process
    pathname2 = fullfile(pathname,'Deconvolution');
    mkdir(pathname2);
    %if ~parallel.gpu.GPUDevice.isAvailable();
     %   warning('No GPU detected, deconvolution will be slow.  Consider running on CUDA enabled system.')
    %end
    psfdecon = psfmaker(psfs,zstepsize,d);
else
    pathname2 = pathname;
    psfdecon = [];
end
imgs1 = zeros(h,w,length(numplanes),length(frameread));
[rawdata,metadata] = nd2channelparse(filename,pathname,channel);
%parfor_progress(length(frameread))
parfor a = frameread
    disp(a);
    %disp(a);
    %metadata(a,:) = MFMmeta(omeMeta,a);
    data = rawdata(:,:,a);
    if flip
        data = fliplr(data);
    end
    if intcorrection
        imgs = MFMparse(data,corners,offset,planes,intscorrect,numplanes);
    else
        imgs = MFMparse(data,corners,offset,planes,ones(9,1),numplanes);
    end
    imgrefsize = size(imgs(:,:,midplane));
    aligndata = MFMalign(imgs,tform,imgrefsize,numplanes);
    %clear imgs;
    if process
        imgs1(:,:,:,a) = mfmdeconvolve3(aligndata,psfdecon,deconviter,radius);
    else
        imgs1(:,:,:,a) = double(aligndata);
    end
    %clear aligndata;
    %parfor_progress;
end
%parfor_progress(0);

if process
    imgs1 = uint16(imgs1/max(imgs1(:))*(2^16-1));
else
    imgs1 = uint16(imgs1);
end

if zinterp
    disp('Z interpolating...');
    imgs1 = mfmzinterp2(imgs1,fitparamsr,fitparamsg,zstepsizeg,zstepsizer);
end
    

%parfor_progress(length(frameread));
disp('Saving...');
if exist(fullfile(pathname2,filesave),'file')
    warning('File already exists, overwriting...');
    delete(fullfile(pathname2,filesave));
end
foo = waitbar(0,'Saving HDF5...');
for a = frameread
    filenum = sprintf(['%0' num2str(leadingzeros) 'd'],a);
    dataset = ['/time' filenum];
    h5create(fullfile(pathname2,filesave),dataset,[h w planes],'Datatype','uint16');
    h5write(fullfile(pathname2,filesave),dataset,imgs1(:,:,:,a))
    waitbar(a/max(frameread),foo);
    %parfor_progress;
end
delete(foo);
%parfor_progress(0);
H5.close
metasave = [filesave '_metadata.csv'];
dlmwrite(fullfile(pathname2,metasave),metadata)
disp('Done!');


    
    
    