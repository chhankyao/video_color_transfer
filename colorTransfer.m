function output = myColorTransfer(input, ref)

% read images
% input = imread('input.jpg');
input = im2double(input);
% ref = imread('ref.jpg');
ref = im2double(ref);

input = rgb2lab(input);
ref = rgb2lab(ref);

mean_s_l = mean2(input(:,:,1));
mean_s_a = mean2(input(:,:,2));
mean_s_b = mean2(input(:,:,3));
std_s_l = std2(input(:,:,1));
std_s_a = std2(input(:,:,2));
std_s_b = std2(input(:,:,3));

mean_r_l = mean2(ref(:,:,1));
mean_r_a = mean2(ref(:,:,2));
mean_r_b = mean2(ref(:,:,3));
std_r_l = std2(ref(:,:,1));
std_r_a = std2(ref(:,:,2));
std_r_b = std2(ref(:,:,3));

output = zeros(size(input));
output(:,:,1) = (input(:,:,1)-mean_s_l)*std_r_l/std_s_l+mean_r_l;
output(:,:,2) = (input(:,:,2)-mean_s_a)*std_r_a/std_s_a+mean_r_a;
output(:,:,3) = (input(:,:,3)-mean_s_b)*std_r_b/std_s_b+mean_r_b;

% ref = lab2rgb(ref);
% input = lab2rgb(input);
output = lab2rgb(output);

% figure; imshow(output);
% imwrite(output, 'output1.jpg');