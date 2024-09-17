function gImg=getGreyscale(img)
    gImg = img(:,:,1) * 0.3 + img(:,:,2) * 0.59 + img(:,:,3) * 0.11;
end