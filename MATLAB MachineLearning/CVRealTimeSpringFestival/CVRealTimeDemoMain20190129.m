%% 初始化工作空间
clc
clear all
close all
% 载入网络(网络名net)
load CSNetSpring.mat
global net counter
%设置图像显示计数器
counter=0;
%% 设置图像输入设备（image acquisition toolbox）
% 查看系统图像输入设备  imaqhwinfo
% Window 设备名称通常为  'winvideo'
%'YUY2_640x480'
vid = videoinput('winvideo', 3,'YUY2_640x480');

% 构造图形输出窗口
fig = figure('Visible', 'off');
vidRes = vid.VideoResolution;
imageRes = fliplr(vidRes);
% subplot(1,2,1)
hImage = imshow(zeros(imageRes));
axis image;
title('实时图像')
% 定制preview刷新函数
setappdata(hImage,'UpdatePreviewWindowFcn',@update_display4);
preview(vid,hImage)

