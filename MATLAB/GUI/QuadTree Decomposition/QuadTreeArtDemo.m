%% 准备图像数据
% 读取
Io=imread('mianjin.jpg');
% 调整为正方形
Io=imresize(Io,[512 512]);
% 彩色转灰度
I = rgb2gray(Io);

%% 图像四叉树分割
S = qtdecomp(I,.1);

%% 构造新图像
newimg=zeros(size(Io));
for i=1:3 
    newimg(:,:,i)=getblocks(S,Io(:,:,i));
end
newimg=uint8(newimg);

%绘图输出
figure(3);
imshow(Io)
title('原图')
figure(4);
imshow(newimg)
title('四叉树艺术图')

