function H = ComputeSpatialTexture(img, rows, cols, bins, thresh)
    imSize = size(img);
    imRows = imSize(1);
    imCols = imSize(2);

    H = [];
    for i = 1:rows
        for j = 1:cols
            rowStart = round((i - 1) * imRows / rows);
            if rowStart == 0
                rowStart = 1;
            end
            rowEnd = round(i * imRows / rows);

            colStart = round((j - 1) * imCols / cols);
            if colStart == 0
                colStart = 1;
            end
            colEnd = round(j * imCols / cols);

            imgCell = img(rowStart:rowEnd, colStart:colEnd, :);
            greyImgCell = getGreyscale(imgCell);

            [magImg, angImg] = getEdgeInfo(greyImgCell);

            eHist = getEdgeAngleHist(magImg, angImg, bins, thresh);

            H = [H eHist];
        end
    end
end