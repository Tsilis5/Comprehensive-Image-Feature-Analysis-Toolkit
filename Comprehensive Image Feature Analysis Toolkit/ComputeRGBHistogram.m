function H = ComputeRGBHistogram(img, Q)
%% Calculate the Global RGB Histogram of an image. Q is quantization level
    qimg = double(img) ./ 256;
    qimg = floor(qimg .* Q);
    bin = qimg(:, :, 1) * Q ^ 2 + qimg(:, :, 2) * Q ^ 1 + qimg(:, :, 3);
    vals = reshape(bin, 1, size(bin, 1) * size(bin, 2));
    H = hist(vals, Q ^ 3);
    H = H ./ sum(H);
end