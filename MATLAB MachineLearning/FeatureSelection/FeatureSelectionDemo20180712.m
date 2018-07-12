%% 初始化工作空间
clc
clear
close all

%% 载入数据
load fisheriris

%% 数据划分
% 随机数种子，为了随机结果的可重复性
rng(1);

% 取出15个数据作为测试数据
cvp = cvpartition(species,'holdout',15);
datTrain = meas(cvp.training,:);
labTrain = species(cvp.training,:);
datTest = meas(cvp.test,:);
labTest = species(cvp.test,:);

%% 目标函数的误差值loss
% 不拟合时的loss
nca = fscnca(datTrain,labTrain,'FitMethod','none');
L0 = loss(nca,datTrain,labTrain);

% lambda为0时的loss
nca = fscnca(datTrain,labTrain,'FitMethod','exact','Lambda',0,...
    'Solver','sgd','Standardize',true);
L1 = loss(nca,datTrain,labTrain);

%% 尝试调整lambda值 (5折交叉验证)
cvp = cvpartition(labTrain,'kfold',5);
numvalidsets=cvp.NumTestSets;
n = length(labTrain);
lambdavals = (0:1:20)/n;
lossvals = zeros(length(lambdavals),numvalidsets);
for i = 1:length(lambdavals)
    for k = 1:numvalidsets
        x = datTrain(cvp.training(k),:);
        y = labTrain(cvp.training(k),:);
        
        xvalid = datTrain(cvp.test(k),:);
        yvalid = labTrain(cvp.test(k),:);
        
        nca = fscnca(x,y,'FitMethod','exact','Solver','sgd','Lambda',lambdavals(i),...
            'IterationLimit',30,'GradientTolerance',1e-4,'Standardize',true);
        lossvals(i,k) = loss(nca,xvalid,yvalid,'LossFunction','classiferror');
    
    end
end
meanloss = mean(lossvals,2);
figure(1);
plot(lambdavals,meanloss,'ro-')
xlabel('Lambda');
ylabel('Loss (MSE)');
grid on

%% 寻找最佳lambda
[~,idx] = min(meanloss);
bestlambda = lambdavals(idx);
bestloss = meanloss(idx);

%% 绘制最佳lambda下的特征权重
nca = fscnca(datTrain,labTrain,'FitMethod','exact','Solver','sgd',...
    'Lambda',bestlambda,'Standardize',true,'Verbose',1);
figure(2)
bar(nca.FeatureWeights)
xlabel('Feature index')
ylabel('Feature weight')
grid on
