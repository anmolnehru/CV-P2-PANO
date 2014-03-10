function [  ] = srgTest(  )
%UNTITLED Summary of this function goes here

currentImg = imread('../images/monona/IMG_1383.JPG');

f=660.86;
x_max= size(currentImg,1);
y_max=size(currentImg,2);
x_c=(1+x_max)/2;
y_c=(1+y_max)/2;

newImg=zeros(x_max*3,y_max*3,3);

%display(size(currentImg,1));
%display(size(currentImg,2));
% % % x' = f*tan((x-xCenter)/f) + xCenter;
% % % y' = (y-yCenter)/cos((y-xCenter)/f) + yCenter;

new_x_max=0;
new_x_min=0;
new_y_max=0;
new_y_min=0;



for r=1:size(newImg,1)
   for c =1:size(newImg,2);
%       theta = atan(r/f); 
%       h=c/sqrt(r^2 +f^2);
%       display(strcat('x=',num2str(r),',y=',num2str(c),',t=',num2str(theta),',h=',num2str(h)));
      
    x=f*tan((r-x_c)/f)+x_c;
    y=(c-y_c)/cos((c-x_c)/f)+y_c;
%     newImg(r,c,0)=currentImg(x,y,0);
%     newImg(r,c,1)=currentImg(x,y,1);
%     newImg(r,c,2)=currentImg(x,y,2);
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




newImg2=zeros(int16(new_x_max-new_x_min),int16(new_y_max-new_y_min ));


new_x_max
new_x_min
new_y_max
new_y_min


for r=1:size(newImg2,1)
   for c =1:size(newImg2,2);
%       theta = atan(r/f); 
%       h=c/sqrt(r^2 +f^2);
%       display(strcat('x=',num2str(r),',y=',num2str(c),',t=',num2str(theta),',h=',num2str(h)));
      
    x=f*tan((r-x_c)/f)+x_c     +new_x_min;
    y=(c-y_c)/cos((c-x_c)/f)+y_c   +new_y_min;
    x=int32(x);
    y=int32(y);
    
     newImg2(r,c,0)=currentImg(x,y,0);
     newImg2(r,c,1)=currentImg(x,y,1);
     newImg2(r,c,2)=currentImg(x,y,2);


   end
end


%imshow(newImg);


end

