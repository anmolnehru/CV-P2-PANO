function check_pair(dir, img0, img1)
% check_pair(dir, img0, img1)
%   Display pixel-wise difference between an aligned image pair in the
%   coordinate frame of img0, along with local features for both images 
%   to provide a visual check of the image alignment.

[d0 c0 d1 c1 H1to0] = load_pair(dir, img0, img1);
dir = deblank(dir);
img0 = load_image(dir, img0);
img1 = load_image(dir, img1);

img1p = map_image(img1, H1to0);
pc1 = apply_homography(c1, H1to0);

delta = abs(img0 - img1p);
%imwrite(delta, sprintf('pair_images/%s-%02d-%02d.png', dir, img0, img1), 'PNG');

clf
imshow(delta);
hold on
plot(c0(1,:),c0(2,:),'b.');
plot(pc1(1,:),pc1(2,:),'ro');
