function [besthomography] = SiftAndRansacRandomN(img1, img2, epsilon)
%UNTITLED Summary of this function goes here
%   the images are 2 rgb image arrays

threshold = 1.5; %default threshold
bigP = 0.99;
smallP = 0.2;

gray1 = GetGrayImageFrom3DArray(img1);
gray2 = GetGrayImageFrom3DArray(img2);
%the sift arrays will be 4 x featurenum arrays
sift1 = vl_sift(gray1);
sift2 = vl_sift(gray2);

%this gives us a 2 x matchnum array where the first row represents column
%in 1st sift feature array and 2nd row represents its matching column in
%2nd sift feature array
matcharr = vl_ubcmatch(sift1, sift2, threshold);

%Now RANSAC method with randomly choosing n on each iteration

besthomography = zeros(3,3);
maxinliers = 0;
k = 0;
while k < 1
    n = round(rand(1) * 15) + 3;
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
    currinliers = 0;
    %now iterate through all of matches and find the num of inliers
    for index = 1:size(matcharr,2)
        point1 = zeros(3);
        point1(1:2) = sift1(1:2, matcharr(1, index));
        point1(3) = 1;
        
        point2predicted = homography * point1;
        
        point2 = zeros(3);
        point2(1:2) = sift2(1:2, matcharr(2, index));
        point2(3) = 1;
        
        dist = norm(point2predicted - point2);
        if (dist < epsilon) 
            currinliers = currinliers + 1;
        end
    end
    
    if (currinliers > maxinliers)
        maxinliers = currinliers;
        besthomography = homography;
    end
    k = k + 1/ round(log(1-bigP) / log(1 - (smallP ^ n)));
end

display(strcat('The maximum number of inliers are ', num2str(maxinliers)));

end

