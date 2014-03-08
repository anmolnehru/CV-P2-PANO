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

%flip rows and columns
minRow = round(minRow);
minCol = round(minCol);
tmp = minCol;
minCol = minRow;
minRow = tmp;
tmp = maxCol;
maxCol = maxRow;
maxRow = tmp;

if (minCol > 0)
    combinedImage = CombineImages(img2, img1, inv(h));
    return;
end

display(strcat('The min row is:', num2str(minRow)));
display(strcat('The min col is:', num2str(minCol)));
display(strcat('The max row is:', num2str(maxRow)));
display(strcat('The max col is:', num2str(maxCol)));

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

%add right image
for i = 1:img2rows
    for j = 1:img2cols
        currPoint = img2(i,j,:);
        if (isequal(currPoint, zeros(1,1,3)))
            continue;
        end

        %This is used for feather blending
        %diff = abs(minCol) - (j + 1);
        diff = abs(maxCol) - (j + 1);
        if (diff > 0)
            if (isequal(combinedImage(i + abs(minRow), j + abs(minCol), :), zeros(1,1,3)))
                combinedImage(i + abs(minRow), j + abs(minCol), :) = currPoint;
                continue;
            end
            weight =  double(maxCol - diff) / double(maxCol);

            r_img1 = (1 - weight) * double(combinedImage(i + abs(minRow), j + abs(minCol), 1));
            g_img1 = (1 - weight) * double(combinedImage(i + abs(minRow), j + abs(minCol), 2));
            b_img1 = (1 - weight) * double(combinedImage(i + abs(minRow), j + abs(minCol), 3));

            r_img2 = weight * double(currPoint(1,1,1));
            g_img2 = weight * double(currPoint(1,1,2));
            b_img2 = weight * double(currPoint(1,1,3));

%             display(r_img1);
%             display(r_img2);
%             display(g_img1);
%             display(g_img2);
%             display(b_img1);
%             display(b_img2);

            combinedImage(i + abs(minRow), j + abs(minCol), 1) = r_img1 + r_img2;
            combinedImage(i + abs(minRow), j + abs(minCol), 2) = g_img1 + g_img2;
            combinedImage(i + abs(minRow), j + abs(minCol), 3) = b_img1 + b_img2;
        else
            combinedImage(i + abs(minRow), j + abs(minCol), :) = currPoint;
        end
    end
end

% Linear interpolation

if (newNumCols < 31 || newNumRows < 31)
    combinedImage = uint8(combinedImage);
    return;
end

for j = 15:newNumCols - 10
    for i = 15:newNumRows - 10
        if (isequal(combinedImage(i,j,:),zeros(1,1,3)))
            combinedImage(i,j,:) = (double(combinedImage(i + 2,j,:)) + ...
                double(combinedImage( i - 2,j,:)) + double(combinedImage(i,j + 2,:)) + ...
                double(combinedImage(i, j - 2,:))) / 4.0;
        end
    end
end

combinedImage = uint8(combinedImage);

end

