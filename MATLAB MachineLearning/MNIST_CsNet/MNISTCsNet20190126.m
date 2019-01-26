%% 准备工作空间
clc
clear all
close all
%% 导入数据
digitDatasetPath = fullfile('./', '/HandWrittenDataset/');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');% 采用文件夹名称作为数据标记
%,'ReadFcn',@mineRF

% 数据集图片个数
countEachLabel(imds)

numTrainFiles = 17;% 每一个数字有22个样本，取17个样本作为训练数据
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');
% 查看图片的大小
img=readimage(imds,1);
size(img)

%% 定义卷积神经网络的结构
layers = [
% 输入层
imageInputLayer([28 28 1])
% 卷积层
convolution2dLayer(5,6,'Padding',2)
batchNormalizationLayer
reluLayer

maxPooling2dLayer(2,'stride',2)

convolution2dLayer(5, 16)
batchNormalizationLayer
reluLayer

maxPooling2dLayer(2,'stride',2)

convolution2dLayer(5, 120)
batchNormalizationLayer
reluLayer
% 最终层
fullyConnectedLayer(10)
softmaxLayer
classificationLayer];

%% 训练神经网络
% 设置训练参数
options = trainingOptions('sgdm',...
    'maxEpochs', 50, ...
    'ValidationData', imdsValidation, ...
    'ValidationFrequency',5,...
    'Verbose',false,...
    'Plots','training-progress');% 显示训练进度

% 训练神经网络，保存网络
net = trainNetwork(imdsTrain, layers ,options);
save 'CSNet.mat' net

%% 标记数据（文件名称方式，自行构造）
mineSet = imageDatastore('./hw22/',  'FileExtensions', '.jpg',...
    'IncludeSubfolders', false);%%,'ReadFcn',@mineRF
mLabels=cell(size(mineSet.Files,1),1);
for i =1:size(mineSet.Files,1)
[filepath,name,ext] = fileparts(char(mineSet.Files{i}));
mLabels{i,1} =char(name);
end
mLabels2=categorical(mLabels);
mineSet.Labels = mLabels2;


%% 使用网络进行分类并计算准确性
% 手写数据
YPred = classify(net,mineSet);
YValidation =mineSet.Labels;
% 计算正确率
accuracy = sum(YPred ==YValidation)/numel(YValidation);
% 绘制预测结果
figure;
nSample=10;
ind = randperm(size(YPred,1),nSample);
for i = 1:nSample
  
subplot(2,fix((nSample+1)/2),i)
imshow(char(mineSet.Files(ind(i))))
title(['预测：' char(YPred(ind(i)))])
if char(YPred(ind(i))) ==char(YValidation(ind(i)))
    xlabel(['真实:' char(YValidation(ind(i)))])
else
    xlabel(['真实:' char(YValidation(ind(i)))],'color','r')
end

end

% 伸缩+反色
% function data =mineRF(filename)
% img= imread(filename);
% data=uint8(255-rgb2gray(imresize(img,[28 28])));
% 
% end

% 二值化 
% function data =mineRF(filename)
% img= imread(filename);
% data=imbinarize(img);
% 
% end

