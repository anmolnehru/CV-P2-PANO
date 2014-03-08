function [ outImg ] = createSimpleStitch( pixArray, outDir )

    outImg=1;
    
    for r=1:size(pixArray,2)
        for c=1:size(pixArray,3)
            I1(r,c,1)=pixArray(1,r,c,1);
            I1(r,c,2)=pixArray(1,r,c,2);
            I1(r,c,3)=pixArray(1,r,c,3);
        end
    end
    
    
    
    for ii=2: size(pixArray,1)

        clear I2;
        clear I1_ori;
        clear I2_ori;
        clear f;
        clear f2;
        clear d;
        clear d2;
        clear fx1;
        clear fx2;
        clear dx1;
        clear dx2;
        clear img2;

        for r=1:size(pixArray,2)
            for c=1:size(pixArray,3)
                I2(r,c,1)=pixArray(ii,r,c,1);
                I2(r,c,2)=pixArray(ii,r,c,2);
                I2(r,c,3)=pixArray(ii,r,c,3);
            end
        end
        
        %images are already cropped
            I1=cropImg(I1);
            I2=cropImg(I2);
        I1_ori=I1;
        I2_ori=I2;      
        
        
        MAX_OVERLAP_Y=size(I2,1)/8;
        MAX_OVERLAP_X=size(I2,2)/2;

        I1 = single(rgb2gray(I1)) ;
        [f,d] = vl_sift(I1) ;
        I2 = single(rgb2gray(I2)) ;
        [f2,d2] = vl_sift(I2) ;

        [matches, scores] = vl_ubcmatch(d, d2, 1) ;       
        
        
        img2=zeros(size(I1_ori,1),size(I1_ori,2)+size(I2_ori,2),3);
        for i=1:size(I2_ori,1)
           for j=1:size(I2_ori,2)
              img2(i,j,:)=I1_ori(i,j,:);
              img2(i,j+size(I1_ori,2),:)=I2_ori(i,j,:);
              
              if(j==MAX_OVERLAP_X)
                  img2(i,j,1)=0;
                  img2(i,j,2)=0;
                  img2(i,j,3)=0;
                  img2(i,j+size(I1_ori,2),1)=0;
                  img2(i,j+size(I1_ori,2),2)=0;
                  img2(i,j+size(I1_ori,2),3)=0;
              end
           end
        end    

        handle = figure ;
        imshow(uint8(img2));
        hold on        
        clear fx1;
        clear fx2;
        clear fy1;
        clear fy2;
        x_sum=0;
        y_sum=0;
        pt_count=0;
        for i=1:size(matches,2)
            i1=matches(1,i);
            i2=matches(2,i);

            x1=f(1,i1);
            x2=f2(1,i2);
            y1=f(2,i1);
            y2=f2(2,i2);
            %display(strcat('(',num2str(x1),',',num2str(y1),') - (',num2str(x2),',',num2str(y2),')' ));

            if(size(I1,2)-x1>MAX_OVERLAP_X || size(I2,2)-x2<MAX_OVERLAP_X)
                continue;
            end

            if(abs(y1-y2)>MAX_OVERLAP_Y)                
              continue;
            end
            
            pt_count=pt_count+1;

            fx1=f(1,i1);
            fx2=f2(1,i2) +size(I1_ori,2);
            fy1=f(2,i1);
            fy2=f2(2,i2);
            
            x_sum=x_sum+(abs(fx1-fx2));
            y_sum=y_sum+(fy1-fy2);
            
            p1 = [fx1,fx2];
            p2 = [fy1,fy2];
            line(p1,p2,'Color','r','LineWidth',.5);
        end
        hold off
        saveas(handle,strcat(outDir,'/switch_',num2str(ii),'.jpg'));

        x_t = round(x_sum/pt_count);
        y_t = round(y_sum/pt_count);


        img3=zeros(size(I1_ori,1),size(I1_ori,2)+size(I2_ori,2)-x_t,3);
        for i=1:size(I2_ori,1)
           for j=1:size(I2_ori,2)
              img3(i,j,:)=I1_ori(i,j,:);
              if(i+y_t<size(I2_ori,1)&&i+y_t>=0)
                  y_plus = y_t;
                  %y_plus = 0;
              else
                  y_plus = 0;
              end
              img3(i+y_plus,j+size(I1_ori,2)-x_t,:)=I2_ori(i,j,:);
              
           end
        end    
        
        img3=cropImg(img3);
        img3=uint8(img3);
        figure;
        imshow(img3);
        imwrite(img3,strcat(outDir,'/pairJoin_',num2str(ii),'.jpg'));
        
        
        clear I1;
        I1=I2_ori;
        
    end     




end

