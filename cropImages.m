function n_im_array = cropImages( im_array, crop_ratio )
%%cropImages Summary
%

[row, col, ~] = size(im_array{1});
center_x = row/2; center_y = col/2;
x_length = crop_ratio*row; y_length = crop_ratio*col;
polygon = [center_y-y_length/2 center_x-x_length/2 y_length x_length]; 

n = size(im_array, 1);
n_im_array = cell(n, 1);
for k = 1:n
    n_im_array{k} = imcrop(im_array{k}, polygon);
end

end