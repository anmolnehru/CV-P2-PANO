function [finalimg] = PanoramaMain(directory)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

pointsToSample = 4;
epsilon = 10;

startup;

%TODO: first read in 2 images from directory
img1;
img2;

%TODO: run SiftAndRansac with various pointsToSample and epsilons and
%choose the best homography matrix based on its determinant etc.

homography = SiftAndRansac(img1, img2, pointsToSample, epsilon);

tform = projective2d(h2);
warped_img1 = imwarp(img1,tform);

end

