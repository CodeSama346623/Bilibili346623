%% 读取鸢尾花数据集
load fisheriris

%%% 检测数据meas
% meas是鸢尾花一些特征的检测结果，矩阵大小150*4
% meas每一行对应一个观测结果，整个数据集有150个观测结果
% meas每一列对应鸢尾花的一种特征属性，
% means的4列对应的属性分别是：萼片长度，萼片宽度，花瓣长度，花瓣宽度

%%% 种类标记 species
% species是鸢尾花种类
% setosa 山鸢尾, versicolor 多色鸢尾, virginica 弗吉尼亚鸢尾
hf1=figure;
hf1.Units='pixels';
hf1.Position=[50 50 900 400];
subplot(1,3,1)
imshow(imread('Iris setosa.jpg'));
title('Iris Setosa 山鸢尾')
subplot(1,3,2)
imshow(imread('Iris versicolor.jpg'));
title('Iris Versicolor 多色鸢尾')
subplot(1,3,3)
imshow(imread('Iris virginica.jpg'));
title('Iris Virginica 弗吉尼亚鸢尾')


% 初始化绘图窗口
hf2=figure;
hf2.Units='pixels';
hf2.Position=[50 50 800 800];
% set(hf,'Position',[50 50 600 600])

%绘制散点图矩阵
speciesNum = grp2idx(species);
[H,AX,BigAx] = gplotmatrix(meas,[],speciesNum,['r' 'g' 'b']);
legend(AX(13+3),{'Setosa 山鸢尾','Versicolor 多色鸢尾','Virginica 弗吉尼亚鸢尾'},'Location','northwest','FontWeight','Bold','Fontsize',10)
title(BigAx,'鸢尾花数据特征散点图矩阵','FontWeight','Bold','Fontsize',16)
%横坐标标题
xlabel(AX(4),{'Sepal Length';'萼片长度'},'FontWeight','Bold','Fontsize',12)
xlabel(AX(8+1),{'Sepal Width';'萼片宽度'},'FontWeight','Bold','Fontsize',12)
xlabel(AX(12+2),{'Petal Length','花瓣长度'},'FontWeight','Bold','Fontsize',12)
xlabel(AX(16+3),{'Petal Width','花瓣宽度'},'FontWeight','Bold','Fontsize',12)
% 纵坐标标题
ylabel(AX(1),{'Sepal Length';'萼片长度'},'FontWeight','Bold','Fontsize',12)
ylabel(AX(2),{'Sepal Width';'萼片宽度'},'FontWeight','Bold','Fontsize',12)
ylabel(AX(3),{'Petal Length','花瓣长度'},'FontWeight','Bold','Fontsize',12)
ylabel(AX(4),{'Petal Width','花瓣宽度'},'FontWeight','Bold','Fontsize',12)







