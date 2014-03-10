function [matchArr] = SiftAndRansac(img1, img2)
%UNTITLED Summary of this function goes here
%   the images are 2 rgb image arrays

threshold = 1.5; %default threshold

gray1 = GetGrayImageFrom3DArray(img1);
gray2 = GetGrayImageFrom3DArray(img2);
sift1 = vl_sift(gray1);
sift2 = vl_sift(gray2);

matchArr = vl_ubcmatch(sift1, sift2);


end

