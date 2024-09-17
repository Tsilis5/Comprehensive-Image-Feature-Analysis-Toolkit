function H = ComputeAverageRGB(img)
    rImg = img(:, :, 1);
    rImg = reshape(rImg, 1, []);
    aRed = mean(rImg);

    gImg = img(:, :, 2);
    gImg = reshape(gImg, 1, []);
    aGreen = mean(gImg);

    bImg = img(:, :, 3);
    bImg = reshape(bImg, 1, []);
    aBlue = mean(bImg);

    H = [aRed, aGreen, aBlue];
end