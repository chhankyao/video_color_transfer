function weightedFusion

contrast_parm = 1;
sat_parm = 1;
wexp_parm = 30;

input = imread('input.jpg');
input = im2double(input);

ref = imread('ref.jpg');
ref = im2double(ref);

input_hmatch = imhistmatch(input, ref);

nlev = 4;

pyr_input_hmatch  = laplacian_pyramid(input_hmatch, nlev);
pyr_input  = laplacian_pyramid(input, nlev);

W = ones(size(input, 1), size(input,2), 2);
if (contrast_parm ~= 0)
    W(:,:,1) = W(:,:,1).*contrast(input).^contrast_parm;
    W(:,:,2) = W(:,:,2).*contrast(input_hmatch).^contrast_parm;
end
if (sat_parm ~= 0)
    W(:,:,1) = W(:,:,1).*saturation(input).^sat_parm;
    W(:,:,2) = W(:,:,2).*saturation(input_hmatch).^sat_parm;
end
if (wexp_parm ~= 0)
    W(:,:,1) = W(:,:,1).*well_exposedness(input).^wexp_parm;
    W(:,:,2) = W(:,:,2).*well_exposedness(input_hmatch).^wexp_parm;
end
W = W + 1e-12;
W = W./repmat(sum(W,3),[1 1 2]);

% w = W(:,:,1);
% m = max(W(:,:,1));
% for i = 1:size(w,1)
%     w(i,:) = w(i,:)/m;
% end

output_pyr = gaussian_pyramid(zeros(size(input)));

pyrW1 = gaussian_pyramid(W(:,:,1), nlev);
pyrW2 = gaussian_pyramid(W(:,:,2), nlev);
for i = 1:nlev
    w1 = repmat(pyrW1{i},[1 1 3]);
    w2 = repmat(pyrW2{i},[1 1 3]);
    if i == nlev
        output_pyr{i} = pyr_input_hmatch{i};
    else
        output_pyr{i} = w1.*pyr_input{i} + w2.*pyr_input_hmatch{i};
    end
end
 
output = reconstruct_laplacian_pyramid(output_pyr);
figure; imshow(output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% contrast measure
function C = contrast(I)
h = [0 1 0; 1 -4 1; 0 1 0]; % laplacian filter
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = rgb2gray(I(:,:,:,i));
    C(:,:,i) = abs(imfilter(mono,h,'replicate'));
end

% saturation measure
function C = saturation(I)
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    % saturation is computed as the standard deviation of the color channels
    R = I(:,:,1,i);
    G = I(:,:,2,i);
    B = I(:,:,3,i);
    mu = (R + G + B)/3;
    C(:,:,i) = sqrt(((R - mu).^2 + (G - mu).^2 + (B - mu).^2)/3);
end

% well-exposedness measure
function C = well_exposedness(I)
sig = .2;
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    R = exp(-.5*(I(:,:,1,i) - .5).^2/sig.^2);
    G = exp(-.5*(I(:,:,2,i) - .5).^2/sig.^2);
    B = exp(-.5*(I(:,:,3,i) - .5).^2/sig.^2);
    C(:,:,i) = R.*G.*B;
end