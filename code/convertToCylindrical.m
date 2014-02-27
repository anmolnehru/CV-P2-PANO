function [ cylindricalImage ] = convertToCylindrical(image, focalLength)
%UNTITLED Summary of this function goes here
%   Takes in 3 dimensional image

%cylindricalImage = zeros
for i = 1:size(image,1)
    for j = 1:size(image,2)
        theta = atan(i/focalLength);
        h = j / sqrt(i^2 + focalLength^2);
        
    end
end


end

