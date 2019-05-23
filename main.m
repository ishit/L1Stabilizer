run('~/vlfeat/toolbox/vl_setup.m');
clear;

% Parameters
num_frames = 1000;
frame_dir = '~/Downloads/frames/';
out_dir = '~/Downloads/frames_opt/';
im_size = [360 640];
crop_ratio = 0.8;

% Read Images
im_array = readImages(frame_dir, num_frames);

% Extract SIFT features
[features, descriptors] = extractSIFT(im_array);

% Get original camera path
t_transforms = getTransforms(im_array, features, descriptors);

%% Save and load variables to reduce re-run times
% save('variables.mat', 'im_array', 't_transforms');
% load('variables.mat');

% Get optimized camera path
n_transforms = optimizeTransforms(t_transforms, im_size);

% Plot camera paths
plotPath(t_transforms, n_transforms);

% Apply new camera path and crop
n_im_array = applyOptimizedTransforms(im_array, n_transforms);

% Save frames
for k=1:num_frames
    file_name = fullfile(out_dir, sprintf('%d.jpg', k));
    imwrite(n_im_array{k}, file_name);
end
