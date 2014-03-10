%  CreateStitchedImage - Iterates through images in pixarray, then 
%       calculates SIFT features and runs a RANSAC variation (with big P 
%       equal to 0.99) based on ransactype parameter entered.
%--------------------------------------------------------------------------
%   Author: Saikat Gomes
%           Steve Lazzaro
%   CS 766 - Assignment 2
%   Params: pixarray - 4d pixel array where first index is the image number
%                       and the rest is the standard image format
%           outDir - directory where the images should be written
%           ransactype - an integer from 1 to 5 that determines which
%                       RANSAC variation to use.  1 is standard, 2 is
%                       regression type, 3 is random epsilons, 4 is random
%                       n's, and 5 is random epsilon and n's
%   
%   Returns: newPanorama - the final panorama image
%   Creates: images in the directory passed in
%--------------------------------------------------------------------------

function [ newPanorama ] = CreateStitchedImage(pixarray, outDir, ransactype)

n = 4;
epsilon = 5;
smallP = 0.2;
type = ransactype;
if (type < 1 || type > 5)
    type = 1;
end

imgrows = size(pixarray,2);
imgcols = size(pixarray,3);

mkdir(outDir);

panorama = cropImg(reshape(pixarray(1,:,:,:),imgrows,imgcols,3));
%keep track of pixel in top left and middle of left image
pixelFirstTopLeft = [1 1 1];
pixelMidTopLeft = [size(panorama,1) / 2, size(panorama,2) / 2, 1];

for i = 2:size(pixarray,1)
    display(strcat('Combining with image: ', num2str(i)));
    currimg = cropImg(reshape(pixarray(i,:,:,:),imgrows,imgcols,3));
    if (type == 1)
        h = SiftAndRansac(currimg, panorama, n, epsilon, smallP);
    elseif (type == 2)
        h = SiftAndRansacMinDist(currimg, panorama, n, smallP);
    elseif (type == 3)
        h = SiftAndRansacRandomEps(currimg, panorama, n, smallP);
    elseif (type == 4)
        h = SiftAndRansacRandomN(currimg, panorama, epsilon, smallP);
    elseif (type == 5)
        h = SiftAndRansacRandomEpsAndN(currimg, panorama, smallP);
    end
    [panorama, topLeftOther, pixelFirstTopLeft, midpointOther, pixelMidTopLeft] = CombineImages(currimg, panorama, h, pixelFirstTopLeft, pixelMidTopLeft);
    imwrite(panorama, strcat(outDir, '/PANO_', num2str(i), '.jpg'));
end

newPanorama = VerticallyAdjustPanorama(panorama, pixelFirstTopLeft, topLeftOther, pixelMidTopLeft, midpointOther);

imwrite(newPanorama, strcat(outDir, '/final_panorama', '.jpg'));

end

