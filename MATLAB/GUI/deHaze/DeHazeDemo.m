% 读取文件
img=imread('.\Dataset\canon.jpg');
% 归一化
img=double(img)./255;
% 去雾
dehazeimg=deHaze(img);

% 对比去雾前后
figure(1);
imshowpair(img,dehazeimg,'montage')

% 对比增强前后
figure(2);
imgEn=histeq(dehazeimg);
imshowpair(dehazeimg,imgEn,'montage')
