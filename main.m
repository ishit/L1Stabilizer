run('~/vlfeat/toolbox/vl_setup.m');
clear;

% Parameters
num_frames = 1000;
frame_dir = '~/Downloads/frames/';
out_dir = '~/Downloads/frames_opt/';
im_size = [360 640];
crop_ratio = 0.9;

% Read Images
im_array = readImages(frame_dir, num_frames);
% Extract SIFT features
[features, descriptors] = extractSIFT(im_array);
% Get cumulative transformation between kth frame and 1st frame
t_transforms = getTransforms(im_array, features, descriptors);
save('variables.mat', 'im_array', 't_transforms');
load('variables.mat');

% Get optimized transformation parameters
n_transforms = optimizeAffineTransforms(t_transforms, im_size);

plotPath(t_transforms, n_transforms);

n_im_array = applyAffineTransforms(im_array, n_transforms);
% Crop frames
crop_im_array = cropImages(n_im_array, crop_ratio);
% Save frames
for k=1:num_frames
    full_name = fullfile(out_dir, sprintf('%d.jpg', k));
    imwrite(crop_im_array{k}, full_name);
end