function [ t_scale, t_theta, t_trans ] = readImages( im_array, features, descriptors )
%getTransforms Summary
%   

num_frames = size(im_array, 1);

% Find matches
tform = cell(num_frames - 1, 1);
t_scale = zeros(num_frames - 1, 1);
t_theta = zeros(num_frames - 1, 1);
t_trans = zeros(num_frames - 1, 2);

for k = 1:num_frames - 1
    [matches, score] = vl_ubcmatch(descriptors{k}, descriptors{k+1});

    % matched_a and matched_b are matched feature points for k and k + 1 images
    matched_a = features{k}(1:2, matches(1, :));
    matched_b = features{k + 1}(1:2, matches(2, :));

    [tform{k}, inlier_a, inlier_b] = estimateGeometricTransform(matched_a', matched_b', 'similarity');

    % Get cumulative transformation, i.e. b/w kth frame and 1st frame
    if ~exist('prev_T', 'var')
        T = tform{k}.T;
    else
        T = prev_T * tform{k}.T;
    end
    
    % The matrix T uses the convention:
    % [x y 1] = [u v 1] * T
    % where T has the form:
    % [a b 0;
    % c d 0;
    % e f 1];

    % s = sqrt(a^2 + c^2) 
    t_scale(k) = sqrt(T(1, 1).^2 + T(2, 1).^2);
    % theta = atan(b / d)
    % Check the similarity matrix
    % t_theta(k) = atan2(T(1, 2), T(2, 2));
    t_theta(k) = atan2(T(2,1), T(1,1));
    t_theta(k) = rad2deg(t_theta(k)) * 1000;
    % tx = e, ty = f
    t_trans(k, :) = T(3, 1:2);

    prev_T = T;
end

end