function fixedname = filenamefix(filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dots = find(filename == '.');

if numel(dots)>1
    filename(dots(1:(end-1))) = '';
end

dashes = find(uint16(filename) == 8211);

if numel(dashes)>0
    filename(dashes) = '';
end

fixedname = filename;