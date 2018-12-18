%% 初始化工作空间
clc
clear all
close all

%% 载入数据
load fisheriris

%% 三维数据
% 花瓣长度、花瓣宽度、花萼长度散点图(无标记)
figure;
speciesNum = grp2idx(species);
plot3(meas(:,3),meas(:,4),meas(:,1),'.','MarkerSize',20)
grid on
view([60,24])
xlabel('花瓣长度')
ylabel('花瓣宽度')
zlabel('萼片长度')
title('无标记')
set(gca,'FontSize',12)
set(gca,'FontWeight','Bold')

% 花瓣长度、花瓣宽度、花萼长度散点图(真实标记)
figure;
hold on
colorArray=['r','g','b'];
for  i= 1:3
    plotind=speciesNum==i;
    plot3(meas(plotind,3),meas(plotind,4),meas(plotind,1),'.','MarkerSize',20,'MarkerEdgeColor',colorArray(i))
end
hold off
grid on
view([60,24])
xlabel('花瓣长度')
ylabel('花瓣宽度')
zlabel('萼片长度')
title('真实标记')
set(gca,'FontSize',12)
set(gca,'FontWeight','Bold')


%% kmeans 聚类
data2=[ meas(:,3), meas(:,4),meas(:,1)];
K=3;
[idx2,cen2]=kmeans(data2,K,'Distance','sqeuclidean','Replicates',5,'Display','Final');
% 调整标号
dist2=sum(cen2.^2,2);
[dump2,sortind2]=sort(dist2,'ascend');
newidx2=zeros(size(idx2));
for i =1:K
    newidx2(idx2==i)=find(sortind2==i);
end

% 花瓣长度和花瓣宽度散点图(真实标记:实心圆+kmeans分类:圈)
figure;
hold on
colorArray=['r','g','b'];
for  i= 1:3
    plotind=speciesNum==i;
    plot3(meas(plotind,3),meas(plotind,4),meas(plotind,1),'.','MarkerSize',15,'MarkerEdgeColor',colorArray(i))
end

for  i= 1:3
    plotind=newidx2==i;
    plot3(meas(plotind,3),meas(plotind,4),meas(plotind,1),'o','MarkerSize',10,'MarkerEdgeColor',colorArray(i))
end
for i=1:3
    plot3(cen2(i,1),cen2(i,2),cen2(i,3),'*m')
end

hold off
grid on
view([60,24])
xlabel('花瓣长度')
ylabel('花瓣宽度')
zlabel('萼片长度')
title('真实标记:实心圆+kmeans分类:圈')
set(gca,'FontSize',12)
set(gca,'FontWeight','Bold')

%% 混淆矩阵 ConfusionMatrix
confMat=confusionmat(speciesNum,newidx2)
error23=speciesNum==2&newidx2==3;
errDat23=data2(error23,:)
error32=speciesNum==3&newidx2==2;
errDat32=data2(error32,:)
[dump, errdatSort]=sort(errDat32(:,3));
errDat32Sort=errDat32(errdatSort,:)
