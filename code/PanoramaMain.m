function [] = PanoramaMain(inDir, f, SIFT_thresh, printVerbose, doSIFT_Test)
    
    DO_FLAG=doSIFT_Test;
    DO_PRINT_IMG=printVerbose;
    startup;
    srgStartup;
    warning('off','all');
    outDir=strcat(inDir,'PANO_',datestr(now,'mmddyyyy_HHMMSSFFF'));
    mkdir(outDir);
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ', ...
        ' Output dir created at ',outDir));
    
    srcFiles = dir(strcat(inDir,'*.*'));     
    [~,order] = sort_nat({srcFiles.name});
    srcFiles = srcFiles(order);
    
    count=0;
    for i = 1 : length(srcFiles)
        if (srcFiles(i).isdir~=1)
            count=count+1;
            inFilename = strcat(inDir,srcFiles(i).name);            
            display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ', ...
                ' Processing file >>> ',inFilename));            
            I = imread(inFilename);            
            NewI = convertToCylindrical(I,f);
            outFilename=strcat(outDir,'/cy_',srcFiles(i).name);  
            
            for r=1:size(NewI,1)
                for c=1:size(NewI,2)
                    pixArray(count,r,c,1)=NewI(r,c,1);
                    pixArray(count,r,c,2)=NewI(r,c,2);
                    pixArray(count,r,c,3)=NewI(r,c,3);
                end
            end            
            
            if(DO_PRINT_IMG==1)                       
                display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ', ...
                    ' Creating file >>> ',outFilename));  
                NewI=cropImg(NewI);
                imwrite(NewI,outFilename);
            end
        end
    end    
    
    if(DO_FLAG==1)   
        SiftTest( pixArray, SIFT_thresh, outDir);                    
    end   
            
    display(strcat(datestr(now,'HH:MM:SS'),' [INFO] ', ...
        ' Creating simple panorama using translation >>>',inFilename));  
    [simpleStitchedImg,simImgCorrected]=createSimpleStitch(pixArray,SIFT_thresh,outDir);
    imwrite(simpleStitchedImg,strcat(outDir,'/panoram.jpg'));
    imwrite(simImgCorrected,strcat(outDir,'/panoramCorrected.jpg'));
    
%     stitchedImg = CreateStitchedImage(pixArray,outDir);
%     imshow(stitchedImg);
    
end