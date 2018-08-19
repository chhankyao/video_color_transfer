function output = gradientPreserving(input, ref)

% read images
% input = imread('input.jpg');
% ref = imread('ref.jpg');
input = im2double(input);
ref = im2double(ref);

height = size(input, 1);
width = size(input, 2);
channel = size(input, 3);
dim = height*width;

f = imhistmatch(input, ref);

f = rgb2lab(f);
input = rgb2lab(input);

D_x = speye(dim, dim);
D_x(height*dim+1:dim+1:end) = -1;
D_y = speye(dim, dim);
D_y(dim+1:dim+1:end) = -1;
m = 1*(transpose(D_x).*D_x + transpose(D_y).*D_y);

output = zeros(height, width, channel);
for i = 1:channel
    v = double(f(:, :, i));
    s = double(input(:, :, i));
    o = (speye(dim)+m) \ (v(:)+(m*s(:)));
    output(:, :, i) = reshape(o, [height, width]);
end

% f = lab2rgb(f);
% input = lab2rgb(input);
output = lab2rgb(output);

% figure; imshow(output);
% imwrite(output, 'output3.jpg');