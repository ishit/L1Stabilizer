function [ features, descriptors ] = extractSIFT( images )
%extractSIFT Summary
% Extracts SIFT features for images.

n = size(images, 1);

% Preallocation
features = cell(n, 1);
descriptors = cell(n, 1);

for k = 1:n
    curr_image = images{k};
    [~, ~, chan] = size(curr_image);
    if(chan == 3)
        [features{k}, descriptors{k}] = vl_sift(single(rgb2gray(curr_image)));
    else
        [features{k}, descriptors{k}] = vl_sift(single(curr_image));
    end
end

end