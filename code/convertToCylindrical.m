function [ convertedImage ] = convertToCylindrical(image, f)
%UNTITLED Summary of this function goes here
%   Takes in 3 dimensional image

rows = size(image,1);
columns = size(image,2);

cylindricalImage = zeros(rows,columns,2);

maxtheta = 0;
mintheta = 9999999999;
maxh = 0;
minh = 999999999999;

for i = 1:rows
    for j = 1:columns
        theta = atan((j - columns/2)/f);
        h = (i - rows/2) / sqrt((j - columns/2)^2 + f^2);

        cylindricalImage(i,j,1) = theta; 
        cylindricalImage(i,j,2) = h;
        
        if (maxtheta < cylindricalImage(i,j,1)) 
            maxtheta = cylindricalImage(i,j,1);
        end
        if (mintheta > cylindricalImage(i,j,1)) 
            mintheta = cylindricalImage(i,j,1);
        end
        if (maxh < cylindricalImage(i,j,2)) 
            maxh = cylindricalImage(i,j,2);
        end
        if (minh > cylindricalImage(i,j,2)) 
            minh = cylindricalImage(i,j,2);
        end
    end
end

convertedImage = zeros(round(maxh),round(maxtheta),3);

for i = 1:rows
    for j = 1:columns
        col_new = round(f * cylindricalImage(i,j,1) + columns/2);
        row_new = round(f * cylindricalImage(i,j,2) + rows/2);
        convertedImage(row_new,col_new,:) = image(i,j,:);
    end
end

convertedImage = uint8(convertedImage);

end

