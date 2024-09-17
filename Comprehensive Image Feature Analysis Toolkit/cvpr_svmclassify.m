%% Load the image collection from each folder %% Part 3 Bovw
imgSets = [imageSet(fullfile('bag_Images', '01')),
           imageSet(fullfile('bag_Images', '02')),
           imageSet(fullfile('bag_Images', '03')),
           imageSet(fullfile('bag_Images', '04')),
           imageSet(fullfile('bag_Images', '05')),
           imageSet(fullfile('bag_Images', '06')),
           imageSet(fullfile('bag_Images', '07')),
           imageSet(fullfile('bag_Images', '08')),
           imageSet(fullfile('bag_Images', '09')),
           imageSet(fullfile('bag_Images', '10')),
           imageSet(fullfile('bag_Images', '11')),
           imageSet(fullfile('bag_Images', '12')),
           imageSet(fullfile('bag_Images', '13')),
           imageSet(fullfile('bag_Images', '14')),
           imageSet(fullfile('bag_Images', '15')),
           imageSet(fullfile('bag_Images', '16')),
           imageSet(fullfile('bag_Images', '17')),
           imageSet(fullfile('bag_Images', '18')),
           imageSet(fullfile('bag_Images', '19')),
           imageSet(fullfile('bag_Images', '20'))];
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
%% Train Test Split(random_state = 0.8)
[trainingSets, validationSets] = partition(imgSets, 0.8, 'randomize');

%% Build the BoVW system using sparse feature detector
bag = bagOfFeatures(trainingSets);

%% Train the SVM model to decide the category           %% Part 4 SVM MODEL 
categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);

%% Calculate the confusion matrix for validation dataset
confMatrix = evaluate(categoryClassifier, validationSets)

%% Input new image and predict its label
newImage = imread('bag_Images/09/9_1_s.bmp');

%% Predict the new image
[labelIdx, scores] = predict(categoryClassifier, newImage);

%% Show the image
figure
imshow(newImage), title(CATEGORIES(labelIdx));