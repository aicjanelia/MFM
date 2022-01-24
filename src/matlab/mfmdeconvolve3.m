function imgs1 = mfmdeconvolve3(imgs,psfdecon,deconviter,radius)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

try
    hasgpu = parallel.gpu.GPUDevice.isAvailable();
catch
    hasgpu = 0;
end

imgsbg = bgsubtract(imgs,radius);
imgsbg = double(imgsbg);

if hasgpu
    imgs1 = deconvlucygpu(imgsbg,psfdecon,deconviter);
    imgs1 = gather(imgs1);
else
    imgs1 = deconvlucy(imgsbg,psfdecon,deconviter);
end