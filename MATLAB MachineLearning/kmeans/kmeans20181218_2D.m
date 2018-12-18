%% 初始化工作空间
clc
clear all
close all

%% 载入数据
load fisheriris

%% 二维数据

% 花瓣长度和花瓣宽度散点图(真实标记)
figure;
speciesNum = grp2idx(species);
gscatter(meas(:,3),meas(:,4),speciesNum,['r','g','b'])
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('真实标记')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

% 花瓣长度和花瓣宽度散点图（无标记）
figure;
scatter(meas(:,3),meas(:,4),150,'.')
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('无标记')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
%% kmeans 聚类
data=[meas(:,3), meas(:,4)];
K=3;
[idx,cen]=kmeans(data,K,'Distance','sqeuclidean','Replicates',5,'Display','Final');
% 调整标号
dist=sum(cen.^2,2);
[dump,sortind]=sort(dist,'ascend');
newidx=zeros(size(idx));
for i =1:K
    newidx(idx==i)=find(sortind==i);
end

% 花瓣长度和花瓣宽度散点图(kmeans分类)
figure;
gscatter(data(:,1),data(:,2),newidx,['r','g','b'])
hold on
scatter(cen(:,1),cen(:,2),300,'m*')
hold off
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('kmeans分类')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

% 花瓣长度和花瓣宽度散点图(真实标记:实心圆+kmeans分类:圈)
figure;
gscatter(meas(:,3),meas(:,4),speciesNum,['r','g','b'])
hold on
gscatter(data(:,1),data(:,2),newidx,['r','g','b'],'o',10)
scatter(cen(:,1),cen(:,2),300,'m*')
hold off
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('真实标记:实心圆+kmeans分类:圈')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

%% 混淆矩阵 ConfusionMatrix
confMat=confusionmat(speciesNum,newidx)
error23=speciesNum==2&newidx==3;
errDat23=data(error23,:)
error32=speciesNum==3&newidx==2;
errDat32=data(error32,:)
