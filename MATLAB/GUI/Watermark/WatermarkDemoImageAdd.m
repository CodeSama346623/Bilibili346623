% 打开原图
imOri=imread('lena.jpg');
%缩放、灰度化原图
imOri=imresize(imOri,[512 512]);
imOri=rgb2gray(imOri);

% 打开水印图
imWat=imread('QQ.png');
% 缩放、灰度化水印图
imWat=imresize(imWat,[512 512]);
imWat=rgb2gray(imWat);

% 加水印后的图
imNew=uint8(double(imOri)+0.05*double(imWat));

% 保存加水印后的图
imwrite(imNew,'lena-QQ.png')

% 绘图 
figure;
imshowpair(imOri,imNew,'montage')

imNew=imread('lena-QQ.png');
figure;
imagesc(double(imOri)-double(imNew))