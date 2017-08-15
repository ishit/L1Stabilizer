run('~/vlfeat/toolbox/vl_setup.m');
run('~/cvx/cvx_setup.m');
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
% Get cumulative transformation between kth frame and 1st frame
[t_scale, t_theta, t_trans] = getTransforms(im_array, features, descriptors);
% Get optimized transformation parameters
[n_scale, n_theta, n_trans] = optimizeTransforms(t_scale, t_theta, t_trans, im_size);
% Apply optimized transformations
n_im_array = applyTransforms(im_array, n_scale, n_theta, n_trans);
% Crop frames
crop_im_array = cropImages(n_im_array, crop_ratio);
% Save frames
for k=1:num_frames
    full_name = fullfile(out_dir, sprintf('%d.jpg', k));
    imwrite(crop_im_array{k}, full_name);
end