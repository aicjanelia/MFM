function tracksbatchanalyze(acqtime,gamma,anomolous,rsqthresh,fitfrac)
%tracksbatchanalyze(acqtime,gamma,anomolous,rsqthresh)
%
%Batch analyze Mosaic tracks to compute diffusion constants and alpha
%values
%
%INPUTS:
%acqtime:  camera acquisition time.  This can be found in the metadata .csv
%file for each dataset
%
%gamma:  4 if 2D diffusion and 6 if 3D diffusion
%
%anomolous:  1 if anomolous diffusion model, 0 for brownian diffusion model
%
%rsqthresh:  R^2 value threshold, below which a track is ignored
%
%This function will automatically save results in a new .mat file with the
%same name as the input file, but with "_analyzed" appended to the
%filename.

[filelist,pathname] = uigetfile('*.mat','Choose particle tracks .mat files','multiselect','on');

if ~iscell(filelist)
    filelist = {filelist};
end
numfiles = length(filelist);
for a = 1:numfiles
    tracks = load(fullfile(pathname,filelist{a}));
    tracks = tracks.tracks;
    [D,alpha] = diffusionconst(tracks,acqtime,gamma,anomolous,rsqthresh,fitfrac);
    Dkeep = D((D>0)&(alpha>0));
    akeep = alpha((D>0)&(alpha>0));
    trackskeep = tracks((D>0)&(alpha>0));
    output.tracks = trackskeep;
    output.D = Dkeep;
    output.alpha = akeep; 
    [~,filepart] = fileparts(filelist{a});
    save(fullfile(pathname,[filepart '_analyzed.mat']),'output');
end

