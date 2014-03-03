function [homography] = ComputeHomography(firstPoints, secondPoints)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

A = zeros(size(firstPoints,2) * 3, 9);
for i = 1:size(firstPoints,2)
    currStartRow = (i-1) * 3 + 1;
    for j = 1:3
        currStartColumn = (j-1) * 3 + 1;
        A(currStartRow + j - 1, currStartColumn) = firstPoints(1,i);
        A(currStartRow + j - 1, currStartColumn + 1) = firstPoints(2,i);
        A(currStartRow + j - 1, currStartColumn + 2) = 1;
    end
end



b = ones(size(secondPoints,2) * 3);
for i = 1:size(secondPoints,2)
    currStartRow = (i-1) * 3 + 1;
    b(currStartRow) = secondPoints(1, i);
    b(currStartRow + 1) = secondPoints(2, i);
end

%Note this does not assume i = 1 but does assume w = 1;
x = A\b;

homography = zeros(3,3);
for i = 1:3
    currStart = (i - 1) * 3 + 1;
    homography(i,:) = x(currStart:currStart+2);
end
    
end

