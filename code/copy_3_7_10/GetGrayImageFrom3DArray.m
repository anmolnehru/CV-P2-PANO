function [grayImage] = GetGrayImageFrom3DArray(img)
% GetGrayImage : get gray version of img passed in
%--------------------------------------------------------------------------
%   Author: Saikat Gomes
%           Steve Lazzaro
%   CS 766 - Assignment 1
%   Params: img - 3-d where 3rd dimension is 1,2, or 3 for RGB
%   Return: grayImage - a 2-D gray version of this image
%--------------------------------------------------------------------------

grayImage = rgb2gray(img);

grayImage = single(grayImage);

end

