function error = myMSE(input, ref, output, lamda)

N_input =  size(input, 1) * size(input, 2);
N_ref =  size(ref, 1) * size(ref, 2);

err_hist = 0;
for i = 1:3
    hist_ref = imhist(ref(:,:,i)) / N_ref;
    hist_output = imhist(output(:,:,i)) / N_input;
    err_hist = err_hist + sum((hist_output - hist_ref) .^ 2);
end

err_grad = 0;
for i = 1:3
    [grad_input, ~] = imgradient(input(:,:,i));
    [grad_output, ~] = imgradient(output(:,:,i));
    err_grad = err_grad + sum((grad_input(:)/256 - grad_output(:)/256) .^ 2) / N_input;
end

error = err_hist + lamda*err_grad;



