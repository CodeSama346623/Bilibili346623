clc
clear all
close all
% 打开原图
imOri=imread('lena.jpg');
%缩放、灰度化原图
imOri=imresize(imOri,[512 512]);
imOri=rgb2gray(imOri);
%哈尔小波变换
[LLorig,LHorig,HLorig,HHorig] = haart2(imOri,2);

% 打开水印图
imWat=imread('logo.jpg');
% 缩放、灰度化水印图
imWat=imresize(imWat,[512 512]);
imWat=rgb2gray(imWat);
%哈尔小波变换
[LLw,LHw,HLw,HHw] = haart2(imWat,2);


% 加水印后的图
Wratio=0.01;
LLwatermarked = LLorig+Wratio*LLw;
imNew = uint8(ihaart2(LLwatermarked,LHorig,HLorig,HHorig));
% 保存加水印后的图
imwrite(imNew,'lena-logo.png')

% 绘图 
figure;
imshowpair(imOri,imNew,'montage')

imNew=imread('lena-logo.png');
figure;
imagesc(double(imOri)-double(imNew))
colormap(gray)