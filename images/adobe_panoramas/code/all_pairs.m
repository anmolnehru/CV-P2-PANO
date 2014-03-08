function pairs = all_pairs(dir)
% pairs = all_pairs(dir)
%       return a 2 x N matrix that specifies all image pairs for the
%       given panorama set that overlap with known homographies.  The
%       first row of the matrix specifies the first image index, and the
%       second row specifies the second image index of the pair.

cwd = pwd;
cd(dir);
files = ls('H*.txt');
m = size(files, 1);
pairs = zeros(2,m);
for i=1:m
    pairs(:, i) = sscanf(files(i,:), 'H%dto%d.txt');
end
cd(cwd);
