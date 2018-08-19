function output = N_Dimensional(input, ref)

% I0 = double(imread('input.jpg'))/255;
% I1 = double(imread('ref.jpg'))/255;
I0 = im2double(input);
I1 = im2double(ref);

% I0 = rgb2lab(I0);
% I1 = rgb2lab(I1);

IR = colour_transfer_IDT(I0,I1,20);

output = IR;
% I0 = lab2rgb(I0);
% I1 = lab2rgb(I1);
% IR = lab2rgb(IR);

% figure; 
% subplot(2,2,1); imshow(I0); title('Original Image'); axis off
% subplot(2,2,2); imshow(I1); title('Target Palette'); axis off
% subplot(2,2,4); imshow(IR); title('Result After Colour Transfer'); axis off
% 
% imwrite(IR, 'output2.jpg');
