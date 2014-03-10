function [] = cropTest(inDir)
    
    
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
            inImg = imread(inFilename);            
                                
                leftMargin=0;
                topMargin=0;
                rightMargin=size(inImg,2);
                bottomMargin=size(inImg,1);
                for c=1:size(inImg,2)-1
                    notWhite=0;
                    for r=1:size(inImg,1)
                       if(inImg(r,c,1)+inImg(r,c,2)+inImg(r,c,3)~=255)
                          notWhite=notWhite+1;               
                       end
                    end
                    if(notWhite==0)
                       leftMargin=c+1;   
                    else
                       break;
                    end        
                end

                for c=size(inImg,2):~1:1
                    notWhite=0;
                    for r=1:size(inImg,1)
                       if(inImg(r,c,1)+inImg(r,c,2)+inImg(r,c,3)~=255)
                          notWhite=notWhite+1;               
                       end
                    end
                    if(notWhite==0)
                       rightMargin=c-1;  
                    else
                       break;
                    end        
                end

                 outImg = imcrop(inImg,[ leftMargin topMargin  rightMargin bottomMargin]);
                
                
            imwrite(outImg,inFilename);
        end
    end    
end