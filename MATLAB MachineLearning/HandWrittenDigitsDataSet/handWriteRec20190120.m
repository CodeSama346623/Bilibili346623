%% 初始化工作空间
clc
clear all
close all
%% 读取图片 
img = imread('handWrite4.jpg');
img=imresize(img,[1024 1024]);
% 图片灰度化，文字反色
imgGray =uint8(255- rgb2gray(img));
% 拉平背景后进行二值化
imgGrayBG=imgaussfilt(imgGray,5);%10 6  5
imgGrayDiff=imgGray-imgGrayBG;
imgBin=imbinarize(imgGrayDiff);
%填补孔洞
imgBin=imopen(imgBin,strel('disk',1));
%
figure(1)
imagesc(imgBin)

%% 提取潜在有效区域的属性（范围、像素面积、像素点位置）
hNum=regionprops(imgBin,'BoundingBox','Area','PixelList');
Area= cat(1,hNum.Area);
BBox=cat(1,hNum.BoundingBox);
%%利用长宽比消除纸张上的长线条
BBoxRatio=BBox(:,3)./BBox(:,4);
Area(BBoxRatio>3)=0;
%% 提取有效面积前10的区域，作为数字0~9的潜在区域
[hmax,hmind]=sort(Area,'descend');
figure;
for i=1:10
subplot(2,5,i)
Swidth = max([BBox(hmind(i),3),BBox(hmind(i),4)]);
Sstart1 =fix( BBox(hmind(i),1));
Sstart2 = fix(BBox(hmind(i),2) );
Swidth1 = BBox(hmind(i),3);
Swidth2 = BBox(hmind(i),4);
PixelList=cat(1,hNum(hmind(i)).PixelList);
% 二值图像
SimgBin=imgBin(Sstart2:(Sstart2+Swidth2-1), Sstart1:(Sstart1+Swidth1-1));
% 灰度图像
SimgGray=imgGray(Sstart2:(Sstart2+Swidth2-1), Sstart1:(Sstart1+Swidth1-1));
SimgGray(~SimgBin) =0; 
% 构造方形的图片
SimgNew = zeros(Swidth,Swidth);
SimgNew(:,fix((Swidth-Swidth1)/2): (fix((Swidth-Swidth1)/2)+Swidth1-1))=SimgGray;

% 绘制结果
imagesc(SimgNew);
colormap(gray)
axis image
% 文件输出
imgOut=uint8(SimgNew);
imgOut = imresize(imgOut, [28 28]);
imwrite(imgOut ,['./newData4/d' num2str(i) '.jpg']);

end
