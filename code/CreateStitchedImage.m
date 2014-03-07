function [ panorama ] = CreateStitchedImage(pixarray, outDir)
%UNTITLED Summary of this function goes here
%   pixarray - 4d pixel array
%   functocall - integer which represents which ransac function to call
%   direction - 1 if first image on right, 2 if our images on left

n = 4;
epsilon = 5;
smallP = 0.5;
direction = 2;

imgrows = size(pixarray,2);
imgcols = size(pixarray,3);

mkdir(outDir);

panorama = cropImg(reshape(pixarray(1,:,:,:),imgrows,imgcols,3));

for i = 2:size(pixarray,1)
    currimg = cropImg(reshape(pixarray(i,:,:,:),imgrows,imgcols,3));
    if (direction == 1)
       % h = SiftAndRansacRandomEpsAndN(panorama, currimg, smallP);
        h = SiftAndRansac(panorama, currimg, n, epsilon, smallP);
        panorama = CombineImages(panorama,currimg, h);
    else
        %h = SiftAndRansacRandomEpsAndN(currimg, panorama, smallP);
        h = SiftAndRansac(currimg, panorama, n, epsilon, smallP);
        panorama = CombineImages(currimg, panorama, h);
    end
    imshow(panorama);
    imwrite(panorama, strcat(outDir, '/PANO_', num2str(i), '.jpg'));
end

imshow(panorama);

end

