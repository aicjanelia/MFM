function beadcalibration2(planes,thresh,edg,objmag,multicolor,filename,pathname,flip,channel)
%function [d,intscorrect,fitparams,tform] = beadcalibration(planes,thresh,edg,zstepsize)
%
%This function can be used to return various parameters related to the MFM
%alignment state and multi-focal grating
%
%Returns:
%d = the interplane distance for a MFM grating
%intscorrect = intensity correction factor for each plane
%fitparams = Cell array giving axial PSF Gaussian fit parameters for all beads in
%each plane
%psfs = Cell parray giving the measured PSF in each plane
%tform = affine transformation matrix to align each plane w/ respect to the central plane.
%
%Inputs:
%planes = number of planes (usually 9)
%thresh = SNR threshold to detect beads (6-10 usually works well)
%edg = distance from image edge in which to ignore beads (10-15 works well)
%zstepsize = sample step size when scanning in z (e.g. 60nm)
%objmag = objective magnification factor
if multicolor
    filenameg = filename{1}; filenamer = filename{2};
    pathnameg = pathname{1}; pathnamer = pathname{2};
    [beadsg,imgsg,zstepsizeg,zmaxg] = beadfinder2(planes,thresh,edg,filenameg,pathnameg,flip(1),channel(1));
    [beadsr,imgsr,zstepsizer,zmaxr] = beadfinder2(planes,thresh,edg,filenamer,pathnamer,flip(2),channel(2));
    beadcheck = input('Beads ok? (y/n)','s');
    if ~strcmp(beadcheck,'n')
        [dg,intscorrectg,fitparamsg] = Zseparation(imgsg,beadsg,zstepsizeg);
        dg = abs(dg);
        [dr,intscorrectr,fitparamsr] = Zseparation(imgsr,beadsr,zstepsizer);
        dr = abs(dr);
        beadtrug = beadloc(imgsg,beadsg,zmaxg);
        beadtrur = beadloc(imgsr,beadsr,zmaxr);
        [tformg,tformr] = beadalign2(imgsg,imgsr,beadtrug,beadtrur,intscorrectg,intscorrectr,zmaxg,zmaxr);
        psfsg = psfviewer(imgsg,beadtrug,fitparamsg);
        psfsr = psfviewer(imgsr,beadtrur,fitparamsr);
        if iscell(filenameg)
            filenameg = cell2mat(filenameg);
        end
        if iscell(filenamer)
            filenamer = cell2mat(filenamer);
        end
        filenameg = filenamefix(filenameg);
        filenamer = filenamefix(filenamer);
        [~,filesaveg] = fileparts(filenameg);
        [~,filesaver] = fileparts(filenamer);
        save([pathnameg filesaveg],'dg','intscorrectg','fitparamsg','psfsg','tformg','zstepsizeg','objmag');
        save([pathnamer filesaver],'dr','intscorrectr','fitparamsr','psfsr','tformr','zstepsizer','objmag','-append');
    else
        error('Beads no good')
    end
else
    [beads,imgs,zstepsize,zmax] = beadfinder2(planes,thresh,edg,filename,pathname,max(flip),max(channel));
    beadcheck = input('Beads ok? (y/n)','s');
    if ~strcmp(beadcheck,'n')
        [d,intscorrect,fitparams] = Zseparation(imgs,beads,zstepsize);
        d = abs(d);
        beadtru = beadloc(imgs,beads,zmax);
        tform = beadalign(imgs,beadtru,intscorrect,zmax);
        psfs = psfviewer(imgs,beadtru,fitparams);
        if iscell(filename)
            filename = cell2mat(filename);
        end
        [~,filesave] = fileparts(filename);
        save([pathname filesave],'d','intscorrect','fitparams','psfs','tform','zstepsize','objmag');
    else
        error('Beads no good')
    end
end
end
