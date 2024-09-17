close all;
clear all;

%% Set the Dataset Folder, Out Folder, Out Subfolder
DATASET_FOLDER = 'msrc_objcategimagedatabase_v2/MSRC_ObjCategImageDatabase_v2';
DESCRIPTOR_FOLDER = 'cwsolutions';
DESCRIPTOR_SUBFOLDER='spatialColor';

%% Set the categories
CATEGORIES = ["Farm Animal" 
    "Tree"
    "Building"
    "Plane"
    "Cow"
    "Face"
    "Car"
    "Bike"
    "Sheep"
    "Flower"
    "Sign"
    "Bird"
    "Book Shelf"
    "Bench"
    "Cat"
    "Dog"
    "Road"
    "Water Features"
    "Human Figures"
    "Coast"
    ];

ALLFEAT=[]; % All features
ALLFILES=cell(1,0); % All files
ALLCATs=[]; % All Categories
ctr=1;

%% Get all files in the dataset
allfiles = dir ("msrc_objcategimagedatabase_v2/MSRC_ObjCategImageDatabase_v2/Images/*.bmp");

%% Read all the images in the dataset and load the global histogram features
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    
    %identify photo category for PR calculation
    split_string = split(fname, '_');
    ALLCATs(filenum) = str2double(split_string(1));
    
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

% get counts for each category for PR calculation
CAT_HIST = histogram(ALLCATs).Values;
CAT_TOTAL = length(CAT_HIST);

%% Run the experiments for run_total times
run_total = 20;
AP_values = zeros([1, run_total]);
for run=1:run_total
    NIMG=size(ALLFEAT,1);           % number of images in collection
    queryimg=floor(rand()*NIMG);    % index of a random image
    if queryimg == 0
        queryimg = 1;
    end
    dst=[];
    %% Calculate the distance from the image to other images
    for i=1:NIMG                    
        candidate=ALLFEAT(i,:);
        query=ALLFEAT(queryimg,:);
        category=ALLCATs(i);
        thedst=cvpr_compare(query,candidate);
        dst=[dst ; [thedst i category]];
    end
    %% Sort the distances
    dst=sortrows(dst,1);  % sort the results
    %% Initialize the precision and recall values
    precision_values=zeros([1, NIMG]);
    recall_values=zeros([1, NIMG]);
    correct_at_n=zeros([1, NIMG]);
    query_row = dst(1,:);
    query_category = query_row(1,3);
    fprintf('category was %s\n', CATEGORIES(query_category))
    %% Binary Classification
    for i=1:NIMG
        rows = dst(1:i, :);
        correct_results = 0;
        incorrect_results = 0;
        if i > 1    
            for n=1:i - 1
                row = rows(n, :);
                category = row(3);
                if category == query_category
                    correct_results = correct_results + 1;
                else
                    incorrect_results = incorrect_results + 1;
                end
            end
        end

    %% Calculate the precision and recall
        % LAST ROW
        row = rows(i, :);
        category = row(3);
        if category == query_category
            correct_results = correct_results + 1;
            correct_at_n(i) = 1;
        else
            incorrect_results = incorrect_results + 1;
        end
        precision = correct_results / i;
        recall = correct_results / CAT_HIST(1,query_category);

        precision_values(i) = precision;
        recall_values(i) = recall;
    end
    %% Plot the precision-recall curve    
    figure(1)
    plot(recall_values, precision_values);
    hold on;
    title('PR Curve');
    xlabel('Recall');
    ylabel('Precision');
    %% Initialize the confusion matrix    
    confusion_matrix = zeros(CAT_TOTAL);    
    %% Show the top 15 images
    SHOW=15; % Show top 15 results
    dst=dst(1:SHOW,:);
    outdisplay=[];
    for i=1:size(dst,1)
       img=imread(ALLFILES{dst(i,2)});
       img=img(1:2:end,1:2:end,:); % make image a quarter size
       img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
       outdisplay=[outdisplay img];
       confusion_matrix(query_category, dst(i,3)) = confusion_matrix(query_category, dst(i,3)) + 1;
    end
    figure(3)
    imshow(outdisplay);
    axis off;
end