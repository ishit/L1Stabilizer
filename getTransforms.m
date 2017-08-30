function transforms = getTransforms( im_array, features, descriptors )
%getTransforms Summary
%  Find original camera path

num_frames = size(im_array, 1);

% Find matches
transforms = cell(num_frames - 1, 1);

for k = 1:num_frames - 1
    [matches, ~] = vl_ubcmatch(descriptors{k}, descriptors{k+1});

    % matched_a and matched_b are matched feature points for k and k + 1 images
    matched_a = features{k}(1:2, matches(1, :));
    matched_b = features{k + 1}(1:2, matches(2, :));
    
    [tform, ~, ~] = estimateGeometricTransform(matched_b', matched_a', 'similarity');

    transforms{k} = tform.T;
end

end