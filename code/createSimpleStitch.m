function [ outImg ] = createSimpleStitch( pixArray, outDir )

    outImg=1;
    
    for r=1:size(pixArray,2)
        for c=1:size(pixArray,3)
            I1(r,c,1)=pixArray(1,r,c,1);
            I1(r,c,2)=pixArray(1,r,c,2);
            I1(r,c,3)=pixArray(1,r,c,3);
        end
    end
    
    
    MAX_OVERLAP=size(I1,1)/2;
    
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

        I1 = single(rgb2gray(I1)) ;
        [f,d] = vl_sift(I1) ;
        I2 = single(rgb2gray(I2)) ;
        [f2,d2] = vl_sift(I2) ;

        [matches, scores] = vl_ubcmatch(d, d2, 1.5) ;       
        
        
        img2=zeros(size(I1_ori,1),size(I1_ori,2)+size(I2_ori,2),3);
        for i=1:size(I2_ori,1)
           for j=1:size(I2_ori,2)
              img2(i,j,:)=I1_ori(i,j,:);
              img2(i,j+size(I1_ori,2),:)=I2_ori(i,j,:);
           end
        end    

        handle = figure ;
        imshow(uint8(img2));
        hold on        
        clear fx1;
        clear fx2;
        clear fy1;
        clear fy2;
        
%         matches

            for i=1:size(matches,2)
                i1=matches(1,i);
                i2=matches(2,i);
                
                x1=f(1,i1);
                x2=f2(1,i2);
            y1=f(2,i1);
            y2=f2(2,i2);
            display(strcat('(',num2str(x1),',',num2str(y1),') - (',num2str(x2),',',num2str(y2),')' ));

                if(size(I1,1)-x1>MAX_OVERLAP || size(I2,1)-x2<MAX_OVERLAP)
                    continue;
                end
                
                fx1=f(1,i1);
                fx2=f2(1,i2)+size(I1_ori,2);
                fy1=f(2,i1);
                fy2=f2(2,i2);
                p1 = [fx1,fx2];
                p2 = [fy1,fy2];
                line(p1,p2,'Color','r','LineWidth',1);
            end
            hold off
            saveas(handle,strcat(outDir,'/switch_',num2str(ii),'.jpg'));
            



% % % %         for i=1:size(matches,2)
% % % %             i1=matches(1,i);
% % % %             i2=matches(2,i);
% % % %             
% % % %             x1=f(1,i1);
% % % %             x2=f2(1,i2);
% % % %             
% % % %             if(size(I1,1)-x1>MAX_OVERLAP || size(I2,1)-x2<MAX_OVERLAP)
% % % %                 break;
% % % %             end
% % % %             
% % % %             y1=f(2,i1);
% % % %             y2=f2(2,i2);
% % % %             
% % % %             display(strcat('(',num2str(x1),',',num2str(y1),') - (',num2str(x2),',',num2str(y2),')' ));
% % % %             
% % % % %             fx1(i)=f(1,i1);
% % % % %             fx2(i)=f2(1,i2);
% % % % %             fy1(i)=
% % % % %             fy2(i)=f2(2,i2);
% % % %         end
        
%         display(fx1);
%         display(fx2);
%         display(fy1);
%         display(fy2);
        
        clear I1;
        I1=I2_ori;
        
    end     




end

