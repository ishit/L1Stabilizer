function transforms = getTransforms( im_array, features, descriptors )
%getTransforms Summary
%   

num_frames = size(im_array, 1);

% Find matches
tform = cell(num_frames - 1, 1);
% Similarity Matrix
% t_scale = zeros(num_frames - 1, 1);
% t_theta = zeros(num_frames - 1, 1);
% t_trans = zeros(num_frames - 1, 2);

% Affine Matrix
t_a = zeros(num_frames - 1, 1);
t_b = zeros(num_frames - 1, 1);
t_c = zeros(num_frames - 1, 1);
t_d = zeros(num_frames - 1, 1);
t_tx = zeros(num_frames - 1, 1);
t_ty = zeros(num_frames - 1, 1);

for k = 1:num_frames - 1
    [matches, ~] = vl_ubcmatch(descriptors{k}, descriptors{k+1});

    % matched_a and matched_b are matched feature points for k and k + 1 images
    matched_a = features{k}(1:2, matches(1, :));
    matched_b = features{k + 1}(1:2, matches(2, :));
    
    [tform{k}, inliersa, inliersb] = estimateGeometricTransform(matched_a', matched_b', 'affine');
    if mod(k, 100) == 0
        figure;
        showMatchedFeatures(im_array{k},im_array{k + 1},...
            inliersa,inliersb);
    end
    % Get cumulative transformation, i.e. b/w kth frame and 1st frame
    % if ~exist('prev_T', 'var')
    %     T = tform{k}.T;
    % else
    %     T = prev_T * tform{k}.T;
    % end
    tform{k} = tform{k}.T;
    % The matrix T uses the convention:
    % [x y 1] = [u v 1] * T
    % where T has the form:
    % [a c 0;
    % b d 0;
    % e f 1];

    % Similarity Matrix
    % s = sqrt(a^2 + c^2) 
    % t_scale(k) = sqrt(T(1, 1).^2 + T(2, 1).^2);
    % theta = atan(b / d)
    % FIXME: Check the similarity matrix
    % t_theta(k) = atan2(T(1, 2), T(2, 2));
    % t_theta(k) = atan2(T(2,1), T(1,1));
    % t_theta(k) = rad2deg(t_theta(k)) * 1000;
    % tx = e, ty = f
    % t_trans(k, :) = T(3, 1:2);

    % Affine Matrix
    % t_a(k) = T(1, 1);
    % t_b(k) = T(2, 1);
    % t_c(k) = T(1, 2);
    % t_d(k) = T(2, 2);

    % t_tx(k) = T(3, 1);
    % t_ty(k) = T(3, 2);

    % prev_T = T;
end

% transforms = [t_tx t_ty t_a t_b t_c t_d];
transforms = tform;
end