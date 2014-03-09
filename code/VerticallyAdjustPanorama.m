function [ newPanorama ] = VerticallyAdjustPanorama(panorama, pixelFirstTopLeft, topLeftOther, pixelMidTopLeft, midpointOther)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

leftMargin=pixelMidTopLeft(2);
topMargin=0;
rightMargin= midpointOther(2) - pixelMidTopLeft(2);
bottomMargin=size(panorama,1);
panorama = imcrop(panorama, [leftMargin topMargin rightMargin bottomMargin]);

theA = (pixelFirstTopLeft(1) - topLeftOther(1)) / topLeftOther(2);
newPanorama = zeros(size(panorama,1) ,size(panorama,2), 3);
for y = 1:size(panorama,1)
    for x = 1:size(panorama,2)
        newY = y + theA * x;
        if (newY < 1 || newY > size(panorama,1))
            continue;
        end
        newY = round(newY);
        newPanorama(newY,x,:) = panorama(y,x,:);
    end
end

newPanorama = uint8(newPanorama);

newPanorama = cropImg(newPanorama);
newPanorama = CropVertical(newPanorama);

%Linear interpolation

for j = 15:size(newPanorama,2) - 10
    for i = 15:size(newPanorama,1) - 10
        if (isequal(newPanorama(i,j,:),zeros(1,1,3)))
            newPanorama(i,j,:) = (double(newPanorama(i + 2,j,:)) + ...
                double(newPanorama( i - 2,j,:)) + double(newPanorama(i,j + 2,:)) + ...
                double(newPanorama(i, j - 2,:))) / 4.0;
        end
    end
end

end