function [xc,yc] = com(x,y,cutout)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

[gridx,gridy] = meshgrid((x-3):(x+3),(y-3):(y+3));
xc = sum(sum(gridx.*cutout,2))./sum(sum(cutout,2));
yc = sum(sum(gridy.*cutout,1))./sum(sum(cutout,1));
end

