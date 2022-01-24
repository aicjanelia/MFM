function plottracks(tracks)
numtracks = length(tracks);
for a = 1:numtracks
    plot3(tracks{a}(:,2),tracks{a}(:,1),tracks{a}(:,3),'color',0.5*rand(1,3)+0.5); hold on
    axis('equal');
end
    