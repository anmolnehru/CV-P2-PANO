function [ outImg ] = CropFromMiddleVertical( inImg , topLeftFirst)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

leftMargin=0;
topMargin=topLeftFirst;
width=size(inImg,2);
height=size(inImg,1) - topLeftFirst;

for r=size(inImg,1):-1:1
    notBlack=0;
    c = round(size(inImg,2) / 2);
    pixSum = inImg(r,c,1)+inImg(r,c,2)+inImg(r,c,3);
    if(pixSum > 18)
       notBlack=notBlack+1;               
    end
    if(notBlack==0)
       height=height-1;  
    else
       break;
    end        
end

outImg = imcrop(inImg,[leftMargin topMargin width height]);

end

