function J = deconvlucygpu(varargin)
%DECONVLUCY Deblur image using Lucy-Richardson method.
%   J = DECONVLUCY(I,PSF) deconvolves image I using Lucy-
%   Richardson algorithm, returning deblurred image J. The assumption is
%   that the image I was created by convolving a true image with a
%   point-spread function PSF and possibly by adding noise.
%   
%   I can be an N-Dimensional array.
%
%   To improve the restoration, additional parameters can be passed in
%   (use [] as a place holder if an intermediate parameter is unknown):
%   J = DECONVLUCY(I,PSF,NUMIT)
%   J = DECONVLUCY(I,PSF,NUMIT,DAMPAR)
%   J = DECONVLUCY(I,PSF,NUMIT,DAMPAR,WEIGHT)
%   J = DECONVLUCY(I,PSF,NUMIT,DAMPAR,WEIGHT,READOUT)
%   J = DECONVLUCY(I,PSF,NUMIT,DAMPAR,WEIGHT,READOUT,SUBSMPL), where
%
%   NUMIT   (optional) is the number of iterations (default is 10).
%
%   DAMPAR  (optional) is an array that specifies the threshold deviation
%   of the resulting image from the image I (in terms of the standard 
%   deviation of Poisson noise) below which the damping occurs. The 
%   iterations are suppressed for the pixels that deviate within the 
%   DAMPAR value from their original value. This suppresses the noise 
%   generation in such pixels, preserving necessary image details
%   elsewhere. Default is 0 (no damping).
%
%   WEIGHT  (optional) is assigned to each pixel to reflect its recording
%   quality in the camera. A bad pixel is excluded from the solution by
%   assigning it zero weight value. Instead of giving a weight of one for
%   good pixels, you can adjust their weight according to the amount of
%   flat-field correction. Default is a unit array of the same size as 
%   input image I.
%
%   READOUT (optional) is an array (or a value) corresponding to the
%   additive noise (e.g., background, foreground noise) and the variance 
%   of the read-out camera noise. READOUT has to be in the units of the
%   image. Default is 0.
%
%   SUBSMPL (optional) denotes subsampling and is used when the PSF is
%   given on a grid that is SUBSMPL times finer than the image. Default
%   is 1.
%
%   Note that the output image J could exhibit ringing introduced by the
%   discrete Fourier transform used in the algorithm. To reduce the
%   ringing use I = EDGETAPER(I,PSF) prior to calling DECONVLUCY.
%
%   Note also that DECONVLUCY allows you to resume deconvolution starting
%   from the results of an earlier DECONVLUCY run. To initiate this
%   syntax, the input image I has to be passed in as cell array, {I}.
%   Then the output J becomes a cell array and can be passed as the input
%   array into the next DECONVLUCY call. The input cell array can contain
%   one numeric array (on initial call), or four numeric arrays (when it
%   is the output from a previous run of DECONVLUCY). The output J
%   contains four elements, where J{1}=I, J{2} is the image resulted from
%   the last iteration, J{3} is the image from one before last iteration,
%   J{4} is an array used internally by the iterative algorithm.
%
%   Class Support
%   -------------
%   I and PSF can be uint8, uint16, int16, double, or single. DAMPAR and
%   READOUT must have the same class as the input image. Other inputs have to
%   be double. The output image (or the first array of the output cell) has
%   the same class as the input image.
%
%   Example
%   -------
%
%      I = checkerboard(8);
%      PSF = fspecial('gaussian',7,10);
%      V = .0001;
%      BlurredNoisy = imnoise(imfilter(I,PSF),'gaussian',0,V);
%      WT = zeros(size(I));WT(5:end-4,5:end-4) = 1;
%      J1 = deconvlucy(BlurredNoisy,PSF);
%      J2 = deconvlucy(BlurredNoisy,PSF,20,sqrt(V));
%      J3 = deconvlucy(BlurredNoisy,PSF,20,sqrt(V),WT);
%      subplot(221);imshow(BlurredNoisy);
%                     title('A = Blurred and Noisy');
%      subplot(222);imshow(J1);
%                     title('deconvlucy(A,PSF)');
%      subplot(223);imshow(J2);
%                     title('deconvlucy(A,PSF,NI,DP)');
%      subplot(224);imshow(J3);
%                     title('deconvlucy(A,PSF,NI,DP,WT)');
%
%   See also DECONVWNR, DECONVREG, DECONVBLIND, EDGETAPER, IMNOISE, PADARRAY, 
%            PSF2OTF, OTF2PSF.

%   Copyright 1993-2013 The MathWorks, Inc.

%

%   References
%   ----------
%   "Acceleration of iterative image restoration algorithms, by D.S.C. Biggs 
%   and M. Andrews, Applied Optics, Vol. 36, No. 8, 1997.
%   "Deconvolutions of Hubble Space Telescope Images and Spectra",
%   R.J. Hanisch, R.L. White, and R.L. Gilliland. in "Deconvolution of Images 
%   and Spectra", Ed. P.A. Jansson, 2nd ed., Academic Press, CA, 1997.

% Parse inputs to verify valid function calling syntaxes and arguments
[J,PSF,NUMIT,DAMPAR,READOUT,WEIGHT,SUBSMPL,sizeI,classI,numNSdim]=...
  parse_inputsgpu(varargin{:});

% 1. Prepare PSF. If PSF is known at a higher sampling rate, it has to be
% padded with zeros up to sizeI(numNSdim)*SUBSMPL in all non-singleton
% dimensions. Or its OTF could take care of it:
sizeOTF = sizeI;
sizeOTF(numNSdim) = SUBSMPL*sizeI(numNSdim);
H = psf2otf(PSF,sizeOTF);
H = gpuArray(H);
% 2. Prepare parameters for iterations
%
% Create indexes for image according to the sampling rate
idx = repmat({':'},[1 length(sizeI)]);
for k = numNSdim,% index replicates for non-singleton PSF sizes only
  idx{k} = reshape(repmat(1:sizeI(k),[SUBSMPL 1]),[SUBSMPL*sizeI(k) 1]);
end

wI = max(WEIGHT.*(READOUT + J{1}),0);% at this point  - positivity constraint
J{2} = J{2}(idx{:});
scale = real(ifftn(conj(H).*fftn(WEIGHT(idx{:})))) + sqrt(eps);
clear WEIGHT;
DAMPAR22 = (DAMPAR.^2)/2;

if SUBSMPL~=1,% prepare vector of dimensions to facilitate the reshaping
  % when the matrix is binned within the iterations.
  vec(2:2:2*length(sizeI)) = sizeI;
  vec(2*numNSdim-1) = -1;
  vec(vec==0) = [];
  num = fliplr(find(vec==-1));
  vec(num) = SUBSMPL;
else
  vec = [];    
  num = [];
end

% 3. L_R Iterations
J{2} = gpuArray(J{2});
J{3} = gpuArray(J{3});
J{4} = gpuArray(J{4});

lambda = 2*any(J{4}(:)~=0);
for k = lambda + (1:NUMIT)
  % 3.a Make an image predictions for the next iteration    
  if k > 2,
    lambda = (J{4}(:,1).'*J{4}(:,2))/(J{4}(:,2).'*J{4}(:,2) +eps);
    lambda = max(min(lambda,1),0);% stability enforcement
  end
  Y = max(J{2} + lambda*(J{2} - J{3}),0);% plus positivity constraint
  
  % 3.b  Make core for the LR estimation
  CC = corelucy(Y,H,DAMPAR22,wI,READOUT,SUBSMPL,idx,vec,num);

  % 3.c Determine next iteration image & apply positivity constraint
  J{3} = J{2};
  J{2} = max(Y.*real(ifftn(conj(H).*CC))./scale,0);  
  clear CC;
  J{4} = [J{2}(:)-Y(:) J{4}(:,1)];
end
clear wI H scale Y;

% 4. Convert the right array (for cell it is first array, for notcell it is
% second array) to the original image class & output whole thing
num = 1 + strcmp(classI{1},'notcell');
if ~strcmp(classI{2},'double'),
  J{num} = images.internal.changeClass(classI{2},J{num});
end

if num==2,% the input & output is NOT a cell
  J = J{2};
end;

