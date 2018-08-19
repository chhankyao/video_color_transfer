function output = ColorGrading(input, ref)

input = im2double(input);
ref = im2double(imresize(ref, [size(input,1), size(input,2)]));

lab_input = rgb2lab(input);
lab_ref = rgb2lab(ref);

a1 = lab_input(:,:,2);
a2 = lab_ref(:,:,2);
b1 = lab_input(:,:,3);
b2 = lab_ref(:,:,3);
m1 = [a1(:), b1(:)]';
m2 = [a2(:), b2(:)]';

t = m2*pinv(m1);
m1 = t*m1;
a1(:) = m1(1,:);
b1(:) = m1(2,:); 
lab_input(:,:,2) = a1;
lab_input(:,:,3) = b1;
output = lab2rgb(lab_input);