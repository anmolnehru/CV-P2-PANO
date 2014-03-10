function [ newPanorama ] = VerticallyAdjustPanorama(panorama, pixelFirstTopLeft, topLeftOther, pixelMidTopLeft, midpointOther)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

leftMargin=pixelMidTopLeft(2);
topMargin=0;
width= midpointOther(2) - pixelMidTopLeft(2);
height=size(panorama,1);
panorama = imcrop(panorama, [leftMargin topMargin width height]);

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
newPanorama = CropFromMiddleVertical(newPanorama, topLeftOther(1) + theA * topLeftOther(2));

newPanorama = InterpolateImage(newPanorama);

end