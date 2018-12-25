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

%% 高斯混合模型聚类
data = [meas(:,3), meas(:,4)];
% 1 自动挡
% GMModel = fitgmdist(data,3);

% 2 手动初始条件
Mu=[0.25 1.5; 4.0 1.25; 5.5 2.0 ];
Sigma(:,:,1) = [1 1;1 2];
Sigma(:,:,2) = [1 1;1 2];
Sigma(:,:,3) = [1 1;1 2];
Pcom=[1/3 1/3 1/3];
S = struct('mu',Mu,'Sigma',Sigma,'ComponentPropotion',Pcom);
GMModel = fitgmdist(data,3,'Start',S);

% 分类
T1 = cluster(GMModel,data);

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

% 花瓣长度和花瓣宽度散点图(真实标记:实心圆+kmeans分类:圈)
figure;
gscatter(meas(:,3),meas(:,4),speciesNum,['r','g','b'])
hold on
gscatter(data(:,1),data(:,2),newT1,['r','g','b'],'o',10)
scatter(cen(:,1),cen(:,2),300,'m*')
hold off
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('真实标记:实心圆+kmeans分类:圈')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

%% 混淆矩阵 ConfusionMatrix
T2ConfMat=confusionmat(speciesNum,newT1)
error23=(speciesNum==2)&(newT1==3);
errDat23=data(error23,:)
error32=(speciesNum==3)&(newT1==2);
errDat32=data(error32,:)

%% 高斯模型等高线图
% 散点图
figure;
gscatter(meas(:,3),meas(:,4),speciesNum,['r','g','b'])
hold on
scatter(cen(:,1),cen(:,2),300,'m*')
hold off
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('高斯模型等高线图')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
% 叠加等高线
haxis=gca;
xlim = get(haxis,'XLim');
ylim = get(haxis,'YLim');
dinter=(max([xlim, ylim]) - min([xlim, ylim]))/100;
[Grid1, Grid2] = meshgrid(xlim(1):dinter:xlim(2), ylim(1):dinter:ylim(2));
hold on
GMMpdf=reshape(pdf(GMModel, [Grid1(:) Grid2(:)]), size(Grid1,1), size(Grid2,2));
contour(Grid1, Grid2, GMMpdf, 30);
hold off

% 混合高斯模型曲面图
figure;
surf(GMMpdf)
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('高斯模型曲面图')
view(-3,65)





