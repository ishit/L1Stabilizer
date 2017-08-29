function n_im_array = applyAffineTransforms( im_array, trans )
%%applyTransforms Summary
%

n = size(im_array, 1);
% Apply optimized transforms
n_im_array = cell(n, 1);
n_im_array{1} = im_array{1};
for k = 2:n
    n_im_array{k} = imwarp(im_array{k}, affine2d(trans{k - 1}));
end
end