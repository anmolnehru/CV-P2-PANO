function [finalimg] = PanoramaMain(inDir, f)

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
            
            if(count==1)
                I1=NewI;
            end
            
            if(count==2)
                I2=NewI;
            end
            
            
            display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ', ...
                ' Creating file>',outFilename));  
            imwrite(NewI,outFilename);
        end
    end
    
    srgStartup;
    figure
    I1 = single(rgb2gray(I1)) ;
    [f,d] = vl_sift(I1) ;
    
    imshow(uint8(I1));
    
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
    
    
    [matches, scores] = vl_ubcmatch(d, d2) ;
    
    display(matches);
    display(scores);
    
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
