clc
clear all
close all

% train a foreground detector
foregroundDetector = vision.ForegroundDetector('NumGaussians',5,...
    'NumTrainingFrames', 30);
videoReader = vision.VideoFileReader('people.avi');

for i = 1:100
    frame = step(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);
end
figure; 
subplot(3,1,1);imshow(frame); title('Video Frame');
subplot(3,1,2);imshow(foreground); title('Foreground');

% clean the foreground
se = strel('disk', 1);
filteredForeground = imopen(foreground, se);
subplot(3,1,3); imshow(filteredForeground); title('Clean Foreground');

% get foreground region objects(FROs)
s  = regionprops(filteredForeground,'BoundingBox','Area','Centroid');
bbox = cat(1, s.BoundingBox);
area=cat(1,s.Area);
centroid=cat(1,s.Centroid);

% filter the FROs with area property
Area=area>5&area<200;
bbox=bbox(Area,:);
centroid=centroid(Area,:);

% hierarchical clustering
Y = pdist(centroid);
Z = linkage(Y);
figure;dendrogram(Z,200);title('Dentrogram')
I = inconsistent(Z);
threshold=mean(Z(:,3))+std(Z(:,3),1)
T = cluster(Z,'cutoff',threshold,'criterion','distance');
Tcen=min(T):1:max(T);
Thist=hist(T,Tcen);
[v,c]=sort(Thist,'descend');

% extract top3 clusters
T1=bbox(T==c(1),:);
T2=bbox(T==c(2),:);
T3=bbox(T==c(3),:);

% get merged bounding box
box1=getBox(T1);
box2=getBox(T2);
box3=getBox(T3);

% plot the results
result = insertShape(frame, 'Rectangle',T1 , 'Color', 'red');
result = insertShape(result, 'Rectangle', box1,'LineWidth',2, 'Color', 'red');
result = insertShape(result, 'Rectangle', T2, 'Color', 'green');
result = insertShape(result, 'Rectangle', box2,'LineWidth',2, 'Color', 'green');
result = insertShape(result, 'Rectangle', T3, 'Color', 'blue');
result = insertShape(result, 'Rectangle', box3,'LineWidth',2, 'Color', 'blue');
numCars = size(bbox, 1);
result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, 'FontSize', 14);
figure; imshow(result); title('Detected People');

% function to get merged bounding box
function box=getBox(box1)
box=[min(box1(:,1)) min(box1(:,2)) ...
    max(box1(:,1)+box1(:,3))-min(box1(:,1))...
    max(box1(:,2)+box1(:,4))-min(box1(:,2))];
end