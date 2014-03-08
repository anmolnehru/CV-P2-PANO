function [img T] = map_image(img, H)
% [img T] = map_image(img, H)
%   Apply homography H to given image. The output image size equals 
%   the input image size.  Also returns the MATLAB transform object 
%   used to do the mapping.

T = maketform('projective', H');
[h w d] = size(img);
img = imtransform(img, T, 'XData', [1 w], 'YData', [1 h]);
