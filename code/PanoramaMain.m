function [matches] = PanoramaMain(inDir, f)

    pointsToSample = 4;
    epsilon = 10;
    %f=660;
    %startup;
    warning('off','all');
    outDir=strcat(inDir,'PANO_',datestr(now,'mmddyyyy_HHMMSSFFF'));
    mkdir(outDir);
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ', ...
        ' Output dir created at ',outDir));
    
    srcFiles = dir(strcat(inDir,'*.*')); 
    count=0;
    for i = 1 : length(srcFiles)
        if (srcFiles(i).isdir~=1)
            count=count+1;
            inFilename = strcat(inDir,srcFiles(i).name);            
            display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ', ...
                ' Processing file>',inFilename));            
            I = imread(inFilename);            
            NewI = convertToCylindrical(I,f);
            outFilename=strcat(outDir,'/cy_',srcFiles(i).name);  
            
            if(count==3)
                I1=NewI;
            end
            
            if(count==4)
                I2=NewI;
            end
            
            
            display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ', ...
                ' Creating file>',outFilename));  
            imwrite(NewI,outFilename);
        end
    end
    
    srgStartup;
    figure
    
    imshow(uint8(I1));
    
    I1 = single(rgb2gray(I1)) ;
    [f,d] = vl_sift(I1) ;
    
    %imshow(uint8(I1));
    
    hold on
    
    perm = randperm(size(f,2)) ;
    
    %display(perm);
    sel = perm(1:100) ;
    %display(sel);
    
    h1 = vl_plotframe(f(:,sel)) ;
    h2 = vl_plotframe(f(:,sel)) ;
    
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
    
    h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
    set(h3,'color','g') ;
    
    hold off;
    
    
    
    figure
    I2 = single(rgb2gray(I2)) ;
    [f2,d2] = vl_sift(I2) ;
    
    imshow(uint8(I2));
    
    hold on
    
    perm2 = randperm(size(f2,2)) ;
    
    %display(perm);
    sel2 = perm2(1:100) ;
    %display(sel);
    
    h1 = vl_plotframe(f2(:,sel2)) ;
    h2 = vl_plotframe(f2(:,sel2)) ;
    
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
    
    h3 = vl_plotsiftdescriptor(d(:,sel2),f2(:,sel2)) ;
    set(h3,'color','g') ;
    
    hold off;
    
    
    
    [matches, scores] = vl_ubcmatch(d, d2, 2.5) ;
    
    
    
    for i=1:size(matches,2)
        i1=matches(1,i);
        i2=matches(2,i);
        fx1(:,i)=f(:,i1);
        fx2(:,i)=f2(:,i2);
        dx1(:,i)=d(:,i1);
        dx2(:,i)=d2(:,i2);
        display(strcat('d1=',num2str(d(i1)),' - i1=',num2str(i1),' --- d2=',num2str(d2(i2)),' - i2=',num2str(i2)));
    end
    
    figure    
    imshow(uint8(I1));
    hold on    
    
    h1 = vl_plotframe(fx1) ;
    h2 = vl_plotframe(fx1) ;
    
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
    
    h3 = vl_plotsiftdescriptor(dx1,fx1) ;
    set(h3,'color','g') ;
    
    hold off;
    
    
    
    figure    
    imshow(uint8(I2));
    hold on    
    
    h1 = vl_plotframe(fx2) ;
    h2 = vl_plotframe(fx2) ;
    
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
    
    h3 = vl_plotsiftdescriptor(dx2,fx2) ;
    set(h3,'color','g') ;
    p1 = [10,100];
    p2 = [100,20];

    plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',2)
    
    hold off;
    
    img2=zeros(size(I1,1),size(I1,2)*2,3);
    for i=1:size(I2,1)
       for j=1:size(I2,2)
          img2(i,j,:)=I1(i,j,:);
          img2(i,j+size(I1,2),:)=I2(i,j,:);
       end
    end    
    
    
    figure 
    
    imshow(uint8(img2));
    
    hold on
    
    for i=1:size(matches,2)
        i1=matches(1,i);
        i2=matches(2,i);
        fx1=f(1,i1);
        fx2=f2(1,i2)+size(I1,2);
        fy1=f(2,i1);
        fy2=f2(2,i2);
        
        p1 = [fx1,fx2];
        p2 = [fy1,fy2];

        %plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',1);
        
        line(p1,p2,'Color','r','LineWidth',1);

        
        %display(strcat('d1=',num2str(d(i1)),' - i1=',num2str(i1),' --- d2=',num2str(d2(i2)),' - i2=',num2str(i2)));
    end
    
    hold off
    
    %display(matches);
    %display(scores);
    
% % % % % %     figure
% % % % % %     
% % % % % %     I2 = single(rgb2gray(I2)) ;
% % % % % %     [f2,d2] = vl_sift(I2) ;
% % % % % %     
% % % % % %     perm2 = randperm(size(f2,2)) ;
% % % % % %     
% % % % % %     display(perm2);
% % % % % %     sel2 = perm2(1:50) ;
% % % % % %     display(sel2);
% % % % % %     
% % % % % %     h4 = vl_plotframe(f2(:,sel2)) ;
% % % % % %     h5 = vl_plotframe(f2(:,sel2)) ;
% % % % % %     
% % % % % %     set(h4,'color','k','linewidth',3) ;
% % % % % %     set(h5,'color','y','linewidth',2) ;
% % % % % %     
% % % % % %     h6 = vl_plotsiftdescriptor(d2(:,sel2),f2(:,sel2)) ;
% % % % % %     set(h6,'color','g') ;
    
    
% % % %     gray1 = GetGrayImageFrom3DArray(I1);
% % % %     gray2 = GetGrayImageFrom3DArray(I2);
% % % %     imshow(uint8(gray1));
% % % %     figure;
% % % %     imshow(uint8(gray2));
% % % %     
% % % %     %the sift arrays will be 4 x featurenum arrays
% % % %     sift1 = vl_sift(gray1);
% % % %     sift2 = vl_sift(gray2);
% % % %     
% % % %     
% % % %     matcharr = vl_ubcmatch(sift1, sift2, threshold);

    
% % % 
% % %     %TODO: run SiftAndRansac with various pointsToSample and epsilons and
% % %     %choose the best homography matrix based on its determinant etc.
% % % 
% % %     homography = SiftAndRansac(img1, img2, pointsToSample, epsilon);
% % % 
% % %     tform = projective2d(h2);
% % %     warped_img1 = imwarp(img1,tform);

end
