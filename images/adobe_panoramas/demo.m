% configure matlab path
setup

% specify the pair of interest
dir = 'data/carmel';
img0 = 0;
img1 = 1;

% show them side by side
figure(1)
imshow([load_image(dir, img0), load_image(dir, img1)]);
title(sprintf('images %02d and %02d from panorama set %s', img0, img1, path_tail(dir)));

% show them aligned with their features
disp('loading and aligning an overlapping image pair...');
figure(2)
check_pair('data/carmel', 0, 1);
title(sprintf('Aligned image difference and mapped features for pair (%02d, %02d) from panorama set %s', img0, img1, path_tail(dir)));
