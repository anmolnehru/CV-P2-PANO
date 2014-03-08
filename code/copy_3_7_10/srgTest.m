function [  ] = srgTest(  )
%UNTITLED Summary of this function goes here

currentImg = imread('../images/monona/IMG_1384.JPG');

imshow(currentImg);
f=660.86;

x_max = size(currentImg,1)
y_max = size(currentImg,2)

newImg=zeros(x_max,y_max,3);
%newImg=currentImg;

x_c=(1+x_max)/2
y_c=(1+y_max)/2

new_x_max=0;
new_x_min=0;
new_y_max=0;
new_y_min=0;


for i=1:x_max
    for j=1:y_max
        
        theta = atan(j - y_max/2/f); 
        h=(i-x_max/2)/sqrt((j- y_max/2)^2 +f^2);
        
        x=f*theta + x_c;
        y=f*h+y_c;
        
        if(x>new_x_max)
            new_x_max=x;
        end
        if(x<new_x_min)
            new_x_min=x;
        end
        if(y>new_y_max)
            new_y_max=y;
        end
        if(y<new_y_min)
            new_y_min=y;
        end
        
    end
end


for i=1:x_max
    for j=1:y_max
        
        theta = atan(i/f); 
        h=j/sqrt(i^2 +f^2);
        
       % [theta,h]= cart2pol(i,j);
        
          x=f*theta + x_c;
          y=f*h+y_c;
         
%          x=x-(new_x_max-x_max);
%          y=y-(new_y_max-y_max);
        
        
        x=f*theta;
        y=f*h;
        
        x=int32(x);
        y=int32(y);
        
    newImg(x,y,1)=(currentImg(i,j,1));
    newImg(x,y,2)=(currentImg(i,j,2));
    newImg(x,y,3)=(currentImg(i,j,3));
        
    end
end
newImg=uint8(newImg);


new_x_max
new_x_min
new_y_max
new_y_min

figure ;
imshow(newImg);


end

