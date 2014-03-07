function [ combinedImage ] = CombineImages(img1, img2, h)
%UNTITLED2 Summary of this function goes here
%
%   The order of the images should be the same as the SiftAndRansac
%   function

minRow = 99999999;
maxRow = 0;
minCol = 99999999;
maxCol = 0;

img1rows = size(img1,1);
img1cols = size(img1,2);
img2rows = size(img2,1);
img2cols = size(img2,2);

testpoints = zeros(3,4);
testpoints(:,1) = [img1rows img1cols 1];
testpoints(:,2) = [img1rows 1 1];
testpoints(:,3) = [1 img1cols 1];
testpoints(:,4) = [1 1 1];

for i = 1:4
    warpedPoint = h * testpoints(:,i);
    if minRow > warpedPoint(1)
        minRow = warpedPoint(1);
    end
    if maxRow < warpedPoint(1)
        maxRow = warpedPoint(1);
    end
    if minCol > warpedPoint(2)
        minCol = warpedPoint(2);
    end
    if maxCol < warpedPoint(2)
        maxCol = warpedPoint(2);
    end
end

minRow = round(minRow);
minCol = round(minCol);
tmp = minCol;
minCol = minRow;
minRow = tmp;
display(minRow);
display(minCol);

newNumRows = abs(minRow) + img2rows;
newNumCols = abs(minCol) + img2cols;
display(newNumRows);
display(newNumCols);

combinedImage = zeros(newNumRows, newNumCols,3);

for i = 1:img1rows
    for j = 1:img1cols
        currPoint = img1(i,j,:);
        warpedPixel = h * [i j 1]';
        combinedImage(round(warpedPixel(1)) + abs(minCol) + 1, round(warpedPixel(2)) + abs(minRow) + 1, :) = currPoint;
    end
end

for i = 1:img2rows
    for j = 1:img2cols
        currPoint = img2(i,j,:);
        combinedImage(i + abs(minRow), j + abs(minCol), :) = currPoint;
    end
end

combinedImage = uint8(combinedImage);

end

