function [ combinedImage, topLeftPixel , pixelFirstTopLeftNew, midpointOther, pixelMidTopLeft] = CombineImages(img1, img2, h, pixelFirstTopLeft, pixelMidTopLeft)
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
    if minRow > warpedPoint(2)
        minRow = warpedPoint(2);
    end
    if maxRow < warpedPoint(2)
        maxRow = warpedPoint(2);
    end
    if minCol > warpedPoint(1)
        minCol = warpedPoint(1);
    end
    if maxCol < warpedPoint(1)
        maxCol = warpedPoint(1);
    end
end

minRow = round(minRow);
minCol = round(minCol);
maxRow = round(maxRow);
maxCol = round(maxCol);

if (minCol > 0)
    [combinedImage, topLeftPixel, pixelFirstTopLeftNew, midpointOther, pixelMidTopLeft] = CombineImages(img2, img1, inv(h), pixelFirstTopLeft, pixelMidTopLeft);
    return;
end

display(strcat('The min row is:', num2str(minRow)));
display(strcat('The min col is:', num2str(minCol)));
display(strcat('The max row is:', num2str(maxRow)));
display(strcat('The max col is:', num2str(maxCol)));
% display(strcat('Img2 rows is:', num2str(img2rows)));
% display(strcat('Img2 cols is:', num2str(img2cols)));

newNumRows = abs(minRow) + img2rows;
newNumCols = abs(minCol) + img2cols;
% display(strcat('The new num rows is:', num2str(newNumRows)));
% display(strcat('The new num cols is:', num2str(newNumCols)));

combinedImage = zeros(newNumRows, newNumCols,3);
combinedImage = uint8(combinedImage);

%add left image
for i = 1:img1rows
    for j = 1:img1cols
        currPoint = img1(i,j,:);
        if (isequal(currPoint, zeros(1,1,3)))
            continue;
        end
        warpedPixel = h * [i j 1]';
        warpedPixel = round(warpedPixel);
        combinedImage(warpedPixel(1) + abs(minCol) + 1, warpedPixel(2) + abs(minRow) + 1, :) = currPoint;
    end
end

warpedTopLeft = h * pixelFirstTopLeft';
warpedTopLeft = round(warpedTopLeft);
pixelFirstTopLeftNew = [warpedTopLeft(1) + abs(minCol) + 1, warpedTopLeft(2) + abs(minRow) + 1, warpedTopLeft(3)];
warpedMidTopLeft = h * pixelMidTopLeft';
warpedMidTopLeft = round(warpedMidTopLeft);
pixelMidTopLeft = [warpedMidTopLeft(1) + abs(minCol) + 1, warpedMidTopLeft(2) + abs(minRow) + 1, warpedMidTopLeft(3)];

%find where the overlap is in columns
overlap_width = 0;
for j = abs(minCol):size(combinedImage,2)
    isBlackCol = true;
    for i = 1:size(combinedImage,1)
        if (~isequal(combinedImage(i, j,:), zeros(1,1,3)))
                isBlackCol = false;
                break;
        end
    end
    if (isBlackCol == true)
        overlap_width = j;
        break;
    end
end

overlap_width = overlap_width - abs(minCol);
maxCol = overlap_width;

%add right image
for i = 1:img2rows
    for j = 1:img2cols
        currPoint = img2(i,j,:);
        if (isequal(currPoint, zeros(1,1,3)))
            continue;
        end

        %This is used for feather blending
        diff = maxCol - j + 1;
        if (diff > 0)
            if (isequal(combinedImage(i + abs(minRow), j + abs(minCol), :), zeros(1,1,3)))
                combinedImage(i + abs(minRow), j + abs(minCol), :) = currPoint;
                continue;
            end
            
            weightImg2 = (maxCol - diff) / maxCol;
            
            r_img1 = (1 - weightImg2) * double(combinedImage(i + abs(minRow), j + abs(minCol), 1));
            g_img1 = (1 - weightImg2) * double(combinedImage(i + abs(minRow), j + abs(minCol), 2));
            b_img1 = (1 - weightImg2) * double(combinedImage(i + abs(minRow), j + abs(minCol), 3));

            r_img2 = weightImg2 * double(currPoint(1,1,1));
            g_img2 = weightImg2 * double(currPoint(1,1,2));
            b_img2 = weightImg2 * double(currPoint(1,1,3));

            combinedImage(i + abs(minRow), j + abs(minCol), 1) = r_img1 + r_img2;
            combinedImage(i + abs(minRow), j + abs(minCol), 2) = g_img1 + g_img2;
            combinedImage(i + abs(minRow), j + abs(minCol), 3) = b_img1 + b_img2;
        else
            combinedImage(i + abs(minRow), j + abs(minCol), :) = currPoint;
        end
    end
end
topLeftPixel = [1 + abs(minRow), 1 + abs(minCol)];
otherRow = round(1 + abs(minRow) + img2rows / 2);
otherCol = round(1 + abs(minCol) + img2cols / 2);
midpointOther = [otherRow, otherCol];

%combinedImage = imresize(combinedImage, 1, 'bilinear');

combinedImage = InterpolateImage(combinedImage);
%combinedImage = InterpolateImage(combinedImage);
%combinedImage = InterpolateImage(combinedImage);

combinedImage = uint8(combinedImage);

end

