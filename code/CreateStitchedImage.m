function [ panorama ] = CreateStitchedImage(pixarray, outDir)
%UNTITLED Summary of this function goes here
%   pixarray - 4d pixel array
%   type - integer which represents which ransac function to call: 1 if
%   normal, 2 if mindist, 3 if random eps, 4 if random n, 5 if random eps
%   and n
%   direction - 1 if first image on right, 2 if first image on left

n = 4;
epsilon = 5;
smallP = 0.5;
direction = 1;
type = 1;

imgrows = size(pixarray,2);
imgcols = size(pixarray,3);

mkdir(outDir);

panorama = cropImg(reshape(pixarray(1,:,:,:),imgrows,imgcols,3));

for i = 2:size(pixarray,1)
    display(strcat('Combining with image: ', num2str(i)));
    currimg = cropImg(reshape(pixarray(i,:,:,:),imgrows,imgcols,3));
    if (direction == 1)
       if (type == 1)
           h = SiftAndRansac(panorama, currimg, n, epsilon, smallP);
       elseif (type == 2)
           h = SiftAndRansacMinDist(panorama, currimg, n, smallP);
       elseif (type == 3)
           h = SiftAndRansacRandomEps(panorama, currimg, n, smallP);
       elseif (type == 4)
           h = SiftAndRansacRandomN(panorama, currimg, epsilon, smallP);
       elseif (type == 5)
           h = SiftAndRansacRandomEpsAndN(panorama, currimg, smallP);
       end
       panorama = CombineImages(panorama,currimg, h);
    else
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
       panorama = CombineImages(currimg, panorama, h);
    end
    imwrite(panorama, strcat(outDir, '/PANO_', num2str(i), '.jpg'));
end

%imshow(panorama);

end

