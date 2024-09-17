close all;
clear all;

%% Set the Dataset Folder, Out Folder, Out Subfolder
DATASET_FOLDER = 'msrc_objcategimagedatabase_v2/MSRC_ObjCategImageDatabase_v2';
OUT_FOLDER = 'cwsolutions';
 %OUT_SUBFOLDER='avgRGB';
% OUT_SUBFOLDER='globalRGBhisto';
 OUT_SUBFOLDER='spatialColor';
%OUT_SUBFOLDER='spatialTexture';
% OUT_SUBFOLDER='spatialColourTexture';

%% Get all files in the dataset
allfiles = dir ("msrc_objcategimagedatabase_v2/MSRC_ObjCategImageDatabase_v2/Images/*.bmp");

%% Calculate the Global Color Histogram of all the images
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name; 
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic; % Calculate the computation time
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img = imread(imgfname_full);
    fout = [OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    % F = ComputeAverageRGB(img);
   %  F = ComputeRGBHistogram(img, 5); % Calculate the histogram
     F = ComputeSpatialColor(img, 4, 4);
    %F = ComputeSpatialTexture(img, 4, 4, 7, 0.09);
  %   F = ComputeSpatialColorTexture(img, 4, 4, 7, 0.09);
    save(fout, 'F') % Save the histogram
    toc;
end
%% 