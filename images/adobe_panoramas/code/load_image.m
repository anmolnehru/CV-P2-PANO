function img = load_image(dir, i)
% img = load_image(dir, i):
%    load and return the i-th image from the panorama set named dir

tail = path_tail(dir);
fprintf(1, 'opening image %s-%02d.png...\n', tail, i);
img = imread(sprintf('%s/%s-%02d.png', dir, tail, i));
