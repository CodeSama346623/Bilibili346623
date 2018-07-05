clc
clear all
close all
% 打开原图
imOri=imread('lena.jpg');
%缩放、灰度化原图
imOri=imresize(imOri,[512 512]);
imOri=rgb2gray(imOri);
%哈尔小波变换
[C,S] = wavedec2(imOri,2,'haar');
[LHorig1,HLorig1,HHorig1] = detcoef2('all',C,S,1);
LLorig1 = appcoef2(C,S,'haar',1); 
[LHorig2,HLorig2,HHorig2] = detcoef2('all',C,S,2);
LLorig2 = appcoef2(C,S,'haar',2); 

% C2 = [LLorig2(:); LHorig2(:); HLorig2(:); HHorig2(:);  LHorig1(:); HLorig1(:); HHorig1(:)];
% S2=S;
% X = waverec2(C2,S2,'haar');

% 打开水印图
imWat=imread('logo.jpg');
% 缩放、灰度化水印图
imWat=imresize(imWat,[512 512]);
imWat=rgb2gray(imWat);
%哈尔小波变换
% [LLw,LHw,HLw,HHw] = haart2(imWat,2);
[C,S] = wavedec2(imWat,2,'haar');
[LHw1,HLw1,HHw1] = detcoef2('all',C,S,1);
LLw1 = appcoef2(C,S,'haar',1); 
[LHw2,HLw2,HHw2] = detcoef2('all',C,S,2);
LLw2 = appcoef2(C,S,'haar',2); 

% 加水印后的图
Wratio=0.01;
LLwatermarked = LLorig2+Wratio*LLw2;
C2 = [LLwatermarked(:); LHorig2(:); HLorig2(:); HHorig2(:);  LHorig1(:); HLorig1(:); HHorig1(:)];
S2=S;
imNew = uint8(waverec2(C2,S2,'haar'));

% 保存加水印后的图
imwrite(imNew,'lena-logo.png')

% 绘图 
figure;
imshowpair(imOri,imNew,'montage')

imNew=imread('lena-logo.png');
figure;
imagesc(double(imOri)-double(imNew))
colormap(gray)