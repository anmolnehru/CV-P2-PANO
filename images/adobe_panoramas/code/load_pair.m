function [desc0 coords0 desc1 coords1 H] = ...
    load_pair(dir, i0, i1)
% [desc0 coords0 desc1 coords1 H1to0] = load_pair(dir, img0, img1)
%   Load local feature descriptors, local feature coordinates, and
%   homography for overlapping pair of images i0 and i1 of the 
%   panorama set specified by dir.
%
%   Input:
%       dir:        the directory for the panorama set
%       img0:       the index for the first image
%       img1:       the index for the second image (img1 > img0)
%
%   Returns:
%       desc0:      128 x M0 matrix of local feature descriptors for img0
%       coords0:    2 x M0 matrix of local feature coordinates for img0
%       desc1:      128 x M1 matrix of local feature descriptors for img1
%       coords1:    2 x M1 matrix of local feature coordinates for img1
%       H1to0:      3 x 3 matrix specifying the homography from img1 to img0
%
%   Errors:
%       If img1 <= img0, then an error occurs.
%       If img1 does not overlap img0, then a warning is displayed and
%           all returned values are empty.

if i1 <= i0
    error('Image pairs must be specified in order such that img0 < img1')
end

cwd=pwd;
cd(dir);

try
    eval(sprintf('load -ascii features-%02d.txt; f0=features_%02d; clear features_%02d',...
        i0, i0, i0));
    eval(sprintf('load -ascii features-%02d.txt; f1=features_%02d; clear features_%02d',...
        i1, i1, i1));
    eval(sprintf('load -ascii H%02dto%02d.txt; H=H%02dto%02d; clear H%02dto%02d', ...
        i1, i0, i1, i0, i1, i0));

    desc0 = f0(:,3:end)';
    coords0 = f0(:,1:2)';

    desc1 = f1(:,3:end)';
    coords1 = f1(:,1:2)';

catch
    desc0 = [];
    coords0 = [];
    desc1 = [];
    coords1 = [];
    H = eye(3);
    fprintf(1, 'Warning: load_pair failed for dir "%s", images %d and %d.\n', ...
        dir, i0, i1);
end
cd(cwd);
