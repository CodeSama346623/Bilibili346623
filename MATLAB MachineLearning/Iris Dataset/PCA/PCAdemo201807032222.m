%% 初始化工作空间
clc
clear
close all

%% 载入数据
load fisheriris

%% 二维数据示例
% 花瓣长度和花瓣宽度散点图
figure;
speciesNum = grp2idx(species);
gscatter(meas(:,3),meas(:,4),speciesNum,['r','g','b'])
% 花瓣长度和宽度的PCA分析
% measRe = score*coeff'+repmat(mu,size(score,1),1);
[coeff, score, latent, tsquared, explained, mu] = pca(meas(:,3:4));
hold on
plot(mu(1)+[0 coeff(1,1)],mu(2)+[0 coeff(2,1)],'r')
plot(mu(1)+[0 coeff(1,2)],mu(2)+[0 coeff(2,2)],'g')
hold off
axis equal
axis([-1 7 -1 7])
xlabel('花瓣长度')
ylabel('花瓣宽度')

%% 四维数据示例
%% 主成分分析 Principal Component Analysis
% measRe = score*coeff'+repmat(mu,size(score,1),1);
[coeff, score, latent, tsquared, explained, mu] = pca(meas);
% PLotMatrix绘制散点图矩阵
% 初始化绘图窗口
hf  = figure;
hf.Units = 'Pixels';
% set(hf,'Units','Pixels');
hf.Position = [50 50 800 800];
% 绘制散点图矩阵
speciesNum = grp2idx(species);
[H,AX,BigAx] = gplotmatrix(score,[],speciesNum,['r','g','b']);
legend(AX(13+3),{'Setosa 山鸢尾','Versicolor 多色鸢尾','Virginica 弗吉尼亚鸢尾'},'Location','northwest','FontWeight','Bold','Fontsize',10)
title(BigAx,'鸢尾花数据PCA散点图矩阵','FontWeight','Bold','Fontsize',16)
%横坐标标题
xlabel(AX(4),{'Component 1';'成分1'},'FontWeight','Bold','Fontsize',12)
xlabel(AX(8+1),{'Component 2';'成分2'},'FontWeight','Bold','Fontsize',12)
xlabel(AX(12+2),{'Component 3','成分3'},'FontWeight','Bold','Fontsize',12)
xlabel(AX(16+3),{'Component 4','成分4'},'FontWeight','Bold','Fontsize',12)
% 纵坐标标题
ylabel(AX(1),{'Component 1';'成分1'},'FontWeight','Bold','Fontsize',12)
ylabel(AX(2),{'Component 2';'成分2'},'FontWeight','Bold','Fontsize',12)
ylabel(AX(3),{'Component 3','成分3'},'FontWeight','Bold','Fontsize',12)
ylabel(AX(4),{'Component 4','成分4'},'FontWeight','Bold','Fontsize',12)
% Biplot绘制向量图
hf2 = figure;
vbls={'萼片长度','萼片宽度','花瓣长度','花瓣宽度'};
biplot(coeff(:,1:3),'Score',score(:,1:3),'Varlabels',vbls);

