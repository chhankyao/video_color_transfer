function output = fusion(input, pmatch, ref, w)

% input = imread('input.jpg');
% ref = imread('ref.jpg');
input = im2double(input);
pmatch = im2double(pmatch);
ref = im2double(ref);

input_hmatch = imhistmatch(input, ref);

%output_pyr = gaussian_pyramid(zeros(size(input,1), size(input,2), 3));
%nlev = length(output_pyr);
nlev = 4;

pyr_input_hmatch  = laplacian_pyramid(input_hmatch, nlev);
pyr_input  = laplacian_pyramid(input, nlev);
pyr_pmatch = laplacian_pyramid(pmatch, nlev);
pyr_w = laplacian_pyramid(w, nlev);

output_pyr = pyr_input;
output_pyr{nlev} = pyr_w{nlev} .* pyr_input_hmatch{nlev} + (1-pyr_w{nlev}) .* pyr_pmatch{nlev};

output = reconstruct_laplacian_pyramid(output_pyr);

% figure; imshow(output);
% imwrite(output, 'output4.jpg');