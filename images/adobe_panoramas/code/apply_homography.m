function p = apply_homography(c, H)
% p = apply_homography(c, H)
%   apply homography H (3x3) to coordinates c (2xN)
p = H * [c; ones(1, size(c, 2))];
p = p(1:2,:) ./ repmat(p(3,:),2,1);
