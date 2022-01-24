function [results,D] = hmmbayesbatch(xyzcols,exposuretime,maxK,locerror)

if nargin < 4
    locerror = 25;
end

if nargin < 3
    maxK = 2;
end

if nargin < 2
    error('Need to specify xyz colunmns and exposure time!')
end

mcmc_params.parallel = 'on'; % turn off if parallel is not available

[filelist,pathname] = uigetfile('*.mat','Choose .mat file(s) containing tracks.','Multiselect','on');
if ~iscell(filelist)
    filelist = {filelist};
end
cd(pathname)
numfiles = length(filelist);
cfg.umperpx = 1;
cfg.fs = 1/exposuretime;
cfg.locerror = locerror/1000;
mkdir(pathname,'TrajectoryImages');
for a = 1:numfiles
    tracks = load(fullfile(pathname,filelist{a}),'-mat','tracks');
    if isstruct(tracks)
        tracks = tracks.tracks;
    end
    numtracks = length(tracks);
    D = [];
    currresults = cell(numtracks,1);
    [~,filestem] = fileparts(filelist{a});
    filesave = [filestem '_hmmbayes.mat'];
    for b = 1:numtracks
        disp(['Analyzing track: ' num2str(b) ' of ' num2str(numtracks) ', File ' num2str(a) ' of ' num2str(numfiles)]);
        track = tracks{b};
        track = track(:,xyzcols);
        track = track'/1000;
        steps = (track(:,2:end) - track(:,1:end-1));
        [currresults{b}.PrM, currresults{b}.ML_states, currresults{b}.ML_params, currresults{b}.full_results, full_fitting, currresults{b}.logI]...
        = hmm_process_dataset(steps,maxK,mcmc_params);
        currresults{b}.track = track;
        currresults{b}.steps = steps;
        hmm_results_plot(cfg,currresults{b});
        saveas(gcf,fullfile(pathname,'TrajectoryImages',[filestem '_trajectory_' num2str(b) '.png']),'png');
        sig = currresults{b}.ML_params.sigma_emit;
        Dcurr = (sig.^2/2-(locerror/1000)^2)./exposuretime;
        D = [D;Dcurr'];
    end
    results.hmmbayesoutput = currresults;
    saveas(gcf,['trajectory ' num2str(a) '.fig'],'fig');
    results.D = D;
    save(fullfile(pathname,filesave),'results');
end
end

