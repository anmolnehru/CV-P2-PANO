%  PanoramaMainRansac - Reads images from directory entered, converts them
%       to cylindrical coordinates, then calculates SIFT features and runs
%       a RANSAC variation based on ransactype parameter entered.
%--------------------------------------------------------------------------
%   Author: Saikat Gomes
%           Steve Lazzaro
%   CS 766 - Assignment 2
%   Params: inDir - relative directory of the *.info file and images
%           f - focal length is f
%           ransactype - an integer from 1 to 5 that determines which
%                       RANSAC variation to use.  1 is standard, 2 is
%                       regression type, 3 is random epsilons, 4 is random
%                       n's, and 5 is random epsilon and n's
%   
%   Returns: stitchedImg - the final panorama image
%   Creates: directory in the input directory containing the images at each
%            iteration of the function and the final cropped panorama 
%--------------------------------------------------------------------------

function [stitchedImg] = PanoramaMainRansac(inDir, f, ransactype)
    
    startup;
    %srgStartup;
    warning('off','all');
    outDir=strcat(inDir,'PANO_',datestr(now,'mmddyyyy_HHMMSSFFF'));
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
            
            for r=1:size(NewI,1)
                for c=1:size(NewI,2)
                    pixArray(count,r,c,1)=NewI(r,c,1);
                    pixArray(count,r,c,2)=NewI(r,c,2);
                    pixArray(count,r,c,3)=NewI(r,c,3);
                end
            end            
        end
    end    
    
%     for i = 1:5
%         currOutDir = strcat(outDir, '_ransactype', num2str(i));
%         stitchedImg  = CreateStitchedImage(pixArray,currOutDir, i);
%     end

    currOutDir = strcat(outDir, '_ransactype', num2str(ransactype));
    stitchedImg  = CreateStitchedImage(pixArray,currOutDir, ransactype);
    imshow(stitchedImg);
end
