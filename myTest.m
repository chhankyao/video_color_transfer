
vi = VideoReader('input2.avi');
vo = VideoReader('output4-7-5.avi');
%vw = VideoWriter('error6-6.avi');
%open(vw);

n = 0;
s = zeros(1, 31);
verb = '';
while (hasFrame(vi) && hasFrame(vo))
    fprintf(repmat('\b',[1, length(verb)]))
    verb = sprintf('frame %d', n);
    fprintf(verb);
    fi = im2double(readFrame(vi));
    fo = im2double(readFrame(vo));
    if (n ~= 0)
        ann_i = nnmex(fi, prev_fi, 'cpu', [], [], [], [], [], [], 1);
        pmatch_i = im2double(votemex(prev_fi, ann_i));
        pmatch_o = im2double(votemex(prev_fo, ann_i));
        mse_i = (pmatch_i - fi) .^ 2;
        mse_o = (pmatch_o - fo) .^ 2;
        tcm = abs(mse_i-mse_o) ./ mse_i;
        %f = im2uint8(tcm);
        %f(tcm < 50) = 255;
        %f(tcm >= 50) = 0;
        %writeVideo(vw, f);
        %mse_i = immse(pmatch_i, fi);
        %mse_o = immse(pmatch_o, fo);
        %s(n) = mse_o / mse_i;
    end
    prev_fi = fi;
    prev_fo = fo;
    n = n + 1;
end
fprintf(repmat('\b',[1, length(verb)]));
%close(vw);
s2 = sum(s) / (n-1);