function output = guidedFilter(input, ref)

% input = imread('input.jpg');
input = im2double(input);

% ref = imread('ref.jpg');
ref = im2double(ref);

input_hmatch = imhistmatch(input, ref);

% h = fspecial('gaussian', [3 3], 0.3);
% filtered_input_hmatch = bfilter2(input_hmatch, 5, [3 0.1]);
% filtered_input = bfilter2(input, 5, [3 0.1]);
filtered_input_hmatch = imguidedfilter(input_hmatch);
filtered_input = imguidedfilter(input);
output = filtered_input_hmatch + (input-filtered_input);

% figure; imshow(output);
% imwrite(output, 'output5.jpg');
