%% 准备工作空间 
clc
clear all
% close all
%% 设置图片路径
image1='sample1-1.jpg';
image2='sample2-1.jpg';
%% 提取图片的SIFT特征点
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);
%% 查找匹配特征点
distRatio = 0.3;   % 设置特征距离阈值, 阈值越小越严格
des2t = des2';                          
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        
   [vals,indx] = sort(acos(dotprods)); %
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end
% match = matchFeatures(des1,des2,  'MatchThreshold', 20,'MaxRatio',0.1 );

% 创建平行图像，显示匹配特征点
im3 = appendimages(im1,im2);
figure('Position', [10 10 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
for i = 1: length(match)
  if (match(i) > 0)
    line([loc1(i,2) loc2(match(i),2)+cols1], ...
         [loc1(i,1) loc2(match(i),1)], 'Color', 'c');
    hold on
    plot(loc1(i,2), loc1(i,1),'ro')
    plot(loc2(match(i),2)+cols1, loc2(match(i),1),'ro')
    hold off
  end
end
hold off;
num = sum(match > 0);
fprintf('Found %d matches.\n', num);

%取出匹配特征点pt1 和 pt2  
ptlen=sum(match>0);
pt1=zeros(ptlen,2);
pt2=zeros(ptlen,2);
counter=1;
for i = 1: size(des1,1)
     if (match(i) > 0)
        pt1(counter,:)=loc1(i,2:-1:1);
        pt2(counter,:)=loc2(match(i),2:-1:1);
        counter=counter+1;
     end
end

%% 通过匹配特征点拟合几何变换
%图1为模板，图2为变换图
% % tform = fitgeotrans(pt2,pt1,'Similarity');
[tform,  inlierPts2, inlierPt1] = estimateGeometricTransform(pt2,pt1,'Similarity');


% 构造模板的变换
tform0 = projective2d(eye(3));
% 计算图片变换后的范围
im1 = imread(image1);
im2 = imread(image2);
imsize1=size(im1);
imsize2=size(im2);
imsizem1=max([imsize1(1),imsize2(1)]);
imsizem2=max([imsize1(2),imsize2(2)]);
% 计算图片空间变换范围
[xlim, ylim]=outputLimits(tform,[1 imsizem2],[1 imsizem1]);
xMin=min([1; xlim(:)]);
xMax=max([imsizem2; xlim(:)]);
yMin=min([1;ylim(:)]);
yMax=max([imsizem1;ylim(:)]);
width=round(xMax-xMin);
height=round(yMax-yMin);
ImMerge=zeros(height,width,3);
xLimits = [xMin xMax];
yLimits = [yMin yMax];
% 以新的图片范围建立坐标系
panoramaView = imref2d([height width], xLimits, yLimits);
%对图1实施变换
Jregistered1 = imwarp(im1,tform0,'OutputView',panoramaView);
mask1 = imwarp(true(size(im1,1),size(im1,2)),tform0,'OutputView',panoramaView);
%对图2实施变换
Jregistered2 = imwarp(im2,tform,'OutputView',panoramaView);
mask2 = imwarp(true(size(im2,1),size(im2,2)),tform,'OutputView',panoramaView);

% 查看变换后图片
figure
imshowpair(Jregistered1,Jregistered2)

%% 图片直接叠加效果
blender=vision.AlphaBlender('Operation','Binary mask',...
    'MaskSource','Input port');
ImMerge=step(blender,ImMerge,double(Jregistered2),mask2);
ImMerge=step(blender,ImMerge,double(Jregistered1),mask1);
figure;
imshow(uint8(ImMerge))

%% 图片梯度加权叠加效果
% 提取遮罩重叠区
maskcross=mask1&mask2;
[~,mcol]=find(maskcross>0);
mcolMin=min(mcol);
mcolMax=max(mcol);
%亮度拉伸参数准备 
im1cross=Jregistered1(maskcross);
im2cross=Jregistered2(maskcross);
im1crossAvg=mean(im1cross);
im2crossAvg=mean(im2cross);
% 提取遮罩左侧坐标
[~,mcol1]=find(mask1>0);
m1colMin=min(mcol1);
[~,mcol2]=find(mask2>0);
m2colMin=min(mcol2);
% 构造图1权重遮罩
immask1=ones(size(mask1));
if m1colMin<m2colMin
    y=linspace(1,0,mcolMax-mcolMin+1);
    ym=repmat(y,size(mask1,1),1);
    immask1(:,mcolMin:mcolMax)=ym;
else
    y=linspace(0,1,mcolMax-mcolMin+1);
    ym=repmat(y,size(mask1,1),1);
    immask1(:,mcolMin:mcolMax)=ym;    
end    
% 构造图2权重遮罩
immask2=ones(size(mask2));
if m1colMin<m2colMin
    y=linspace(0,1,mcolMax-mcolMin+1);
    ym=repmat(y,size(mask2,1),1);
    immask2(:,mcolMin:mcolMax)=ym;
else
    y=linspace(1,0,mcolMax-mcolMin+1);
    ym=repmat(y,size(mask2,1),1);
    immask2(:,mcolMin:mcolMax)=ym;
 
end

% 图像融合
blender=vision.AlphaBlender('Operation','blend',...
    'OpacitySource','Input port');
ImMergeBlank=zeros(height,width,3);
ImMerge1=step(blender,ImMergeBlank,double(Jregistered1),immask1);
ImMerge2=step(blender,ImMergeBlank,double(Jregistered2)/im2crossAvg*im1crossAvg,immask2);
%查看融合结果
figure;
imshow(uint8(ImMerge1+ImMerge2))
imwrite(uint8(ImMerge1+ImMerge2),'merge.jpg')








