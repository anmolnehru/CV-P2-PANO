function [ outImg ] = cropImg( inImg )

    leftMargin=0;
    topMargin=0;
    width=size(inImg,2);
    height=size(inImg,1);
    for c=1:size(inImg,2)-1
        notBlack=0;
        for r=1:size(inImg,1)
           if(inImg(r,c,1)+inImg(r,c,2)+inImg(r,c,3)~=0)
              notBlack=notBlack+1;               
           end
        end
        if(notBlack==0)
           leftMargin=leftMargin+1;
           width = width - 1;   
        else
           break;
        end        
    end
    
    for c=size(inImg,2):-1:1
        notBlack=0;
        for r=1:size(inImg,1)
           if(inImg(r,c,1)+inImg(r,c,2)+inImg(r,c,3)~=0)
              notBlack=notBlack+1;               
           end
        end
        if(notBlack==0)
           width=width-1;  
        else
           break;
        end        
    end

     outImg = imcrop(inImg,[ leftMargin topMargin  width height]);
     
end

