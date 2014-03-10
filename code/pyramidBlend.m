function [ pyrImg ] = pyramidBlend( I1,I2 )

    % based on Wiggin

    img1 = im2double(I1);
    img2 = im2double(I2); 
    [M N ~] = size(img1);

    v = 230;
    l = 1;
    lap1 = genPyr(img1,'lap',l); % the Laplacian pyramid
    lap2 = genPyr(img2,'lap',l);

    m1 = zeros(size(img1));
    m1(:,1:v,:) = 1;
    m2 = 1-m1;
    b = fspecial('gauss',2,1); % feather the border
    m1 = imfilter(m1,b,'replicate');
    m2 = imfilter(m2,b,'replicate');

    pBlend = cell(1,l); % the blended pyramid
    for p = 1:l
        [Mp Np ~] = size(lap1{p});
        maskap = imresize(m1,[Mp Np]);
        maskbp = imresize(m2,[Mp Np]);
        pBlend{p} = lap1{p}.*maskap + lap2{p}.*maskbp;
    end
    pyrImg = pyrReconstruct(pBlend); 

end

