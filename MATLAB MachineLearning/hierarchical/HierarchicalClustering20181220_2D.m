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

%% 层次聚类
data=[meas(:,3), meas(:,4)];
datalink=linkage(data,'average','euclidean');
% 绘制树状图
figure;
dendrogram(datalink,10)
title('树状图（10节点）')
figure;
dendrogram(datalink,0)
title('树状图（所有节点）')

%% 分割方式1：距离阈值
T1 = cluster(datalink,'cutoff',1.2,'Criterion','distance');
% 标号调整
cen=[mean(data(T1==1,:));...
    mean(data(T1==2,:));...
    mean(data(T1==3,:))];
dist=sum(cen.^2,2);
[dump,sortind]=sort(dist,'ascend');
newT1=zeros(size(T1));
for i =1:3
    newT1(T1==i)=find(sortind==i);
end

%% 分割方式2：群数目
T2 = cluster(datalink,'maxclust',3);
% 标号调整
cen=[mean(data(T2==1,:));...
    mean(data(T2==2,:));...
    mean(data(T2==3,:))];
dist=sum(cen.^2,2);
[dump,sortind]=sort(dist,'ascend');
newT2=zeros(size(T2));
for i =1:3
    newT2(T2==i)=find(sortind==i);
end

% 花瓣长度和花瓣宽度散点图(真实标记:实心圆+kmeans分类:圈)
figure;
gscatter(meas(:,3),meas(:,4),speciesNum,['r','g','b'])
hold on
gscatter(data(:,1),data(:,2),newT2,['r','g','b'],'o',10)
scatter(cen(:,1),cen(:,2),300,'m*')
hold off
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('真实标记:实心圆+kmeans分类:圈')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

%% 混淆矩阵 ConfusionMatrix
T2ConfMat=confusionmat(speciesNum,newT2)
error23=(speciesNum==2)&(newT2==3);
errDat23=data(error23,:)
error32=(speciesNum==3)&(newT2==2);
errDat32=data(error32,:)
