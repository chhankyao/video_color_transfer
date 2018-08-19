
v = VideoReader('input.avi');
frames = read(v);
ref = imread('ref.jpg');

output = zeros(size(frames));
prev_frame = frames(:,:,:,1);
prev_output = im2uint8(fusion(frames(:,:,:,1), frames(:,:,:,1), ref, ones(size(frames(:,:,:,1)))));
verb = '';
for i = 1 : size(frames, 4)
    fprintf(repmat('\b',[1, length(verb)]))
    verb = sprintf('frame %d', i);
    fprintf(verb);
    current_frame = frames(:,:,:,i);
    ann_i = nnmex(current_frame, prev_frame, 'cpu', [], [], [], [], [], [], 1);
    pmatch = votemex(prev_output, ann_i);
    ann = double(ann_i(1:end-6, 1:end-6, 3));
    w = double(ann_i(:,:,3)) / (max(ann(:))+1e-10);
    w(w > 1) = 1;
    w = repmat(w, [1,1,3]);
    % style transfer
    trans = im2uint8(fusion(current_frame, pmatch, ref, w));
    output(:,:,:,i) = im2double(trans);
    prev_frame = current_frame;
    prev_output = trans;
end
fprintf(repmat('\b',[1, length(verb)]))

v = VideoWriter('output4-7-3.avi');
open(v);
writeVideo(v, output);
close(v);
