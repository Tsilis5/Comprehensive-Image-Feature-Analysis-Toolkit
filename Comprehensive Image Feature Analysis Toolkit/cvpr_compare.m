function dst = cvpr_compare(a, b)
%% Calculate the euclidean distance from a to b
    dst = sqrt(sum((a - b) .^ 2));
return;