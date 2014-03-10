function [ newPanorama ] = CreateStitchedImage(pixarray, outDir, ransactype)
%UNTITLED Summary of this function goes here
%   pixarray - 4d pixel array
%   type - integer which represents which ransac function to call: 1 if
%   normal, 2 if mindist, 3 if random eps, 4 if random n, 5 if random eps
%   and n

n = 4;
epsilon = 5;
smallP = 0.3;
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

%imshow(panorama);

end

