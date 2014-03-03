function [matcharr, sift1, sift2] = SiftAndRansac(img1, img2, n)
%UNTITLED Summary of this function goes here
%   the images are 2 rgb image arrays

threshold = 1.5; %default threshold
bigP = 0.99;
smallP = 0.2;

if (n < 3)
    n = 3;
end

gray1 = GetGrayImageFrom3DArray(img1);
gray2 = GetGrayImageFrom3DArray(img2);
%the sift arrays will be 4 x featurenum arrays
sift1 = vl_sift(gray1);
sift2 = vl_sift(gray2);

%this gives us a 2 x matchnum array where the first row represents column
%in 1st sift feature array and 2nd row represents its matching column in
%2nd sift feature array
matcharr = vl_ubcmatch(sift1, sift2, threshold);

if (n > size(matcharr,2))
    display('n is larger than the number of feature matches, please try again');
    return;
end

%Now RANSAC method

k = log(1-bigP) / log(1 - (smallP ^ n));



for i = 1:k
    [points, idx] = datasample(matcharr,n,2); %get n random points
    %these will be 2 x n arrays of the points used for computing the
    %homography matrix
    firstPoints = zeros(2,n);
    secondPoints = zeros(2,n);
    for j = 1:size(points,2);
        firstPoints(:,j) = sift1(1:2, points(1,j));
        secondPoints(:,j) = sift1(1:2, points(2,j));
    end
    homography = ComputeHomography(firstPoints, secondPoints);
    
end


end

