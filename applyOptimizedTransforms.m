function n_im_array = applyOptimizedTransforms( im_array, n_transforms )
%%applyOptimizedTransforms Summary
%  Applies optimized camera path n_transforms to im_array

num_frames = size(im_array, 1);
crop_ratio = 0.8;
[height, width, ~] = size(im_array{1});
center_x = width/2; center_y = height/2;
x_length = crop_ratio*width; y_length = crop_ratio*height;

n_im_array = cell(num_frames, 1);

for k=2:num_frames
    % Transform crop window
    p1 = [center_x - x_length/2 center_y - y_length/2 1];
    p2 = [center_x - x_length/2 center_y + y_length/2 1];
    p3 = [center_x + x_length/2 center_y + y_length/2 1];
    p4 = [center_x + x_length/2 center_y - y_length/2 1];
    p1 = p1 * n_transforms{k - 1}; p2 = p2 * n_transforms{k - 1};
    p3 = p3 * n_transforms{k - 1}; p4 = p4 * n_transforms{k - 1};
    
    % Find homography and crop
    Xin = [p1(1) p2(1) p3(1) p4(1)];
    Yin = [p1(2) p2(2) p3(2) p4(2)];
    Xout = [1 1 width width];
    Yout = [1 height height 1];
    
    in = [Xin; Yin]; out = [Xout; Yout];
    tform = estimateGeometricTransform(in',out','projective');
    R = imref2d([360 640 3]);
    n_im_array{k} = imwarp(im_array{k},tform,'cubic','OutputView',R);
    
end

% Apply same transformation to 1st frame as in the 2nd frame
n_im_array{1} = n_im_array{2};

end