function [ images_array ] = readImages( image_dir, max )
%readImages Summary
% Reads images in the give directory and returns a cell array.

% Read images
file_names = fullfile(image_dir, '*.jpg');
image_files = dir(file_names);

% Number of frames for testing
n = min([length(image_files) max]);

% Preallocation
images_array = cell(n, 1);

for k = 1:n
    base_name = image_files(k).name;
    full_name = fullfile(image_dir, base_name);
    fprintf(1, 'Now reading %s\n', full_name);
    im = imread(full_name);
    im = imresize(im, [360 640]);
    images_array{k} = im;
end

end