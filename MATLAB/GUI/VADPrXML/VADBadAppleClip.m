%% 准备工作空间
    clc
    close all
    clear all

%% 读取节奏音频 
    filename2 = 'BadAppleClip.mp3';
    [sdata2, fs2] = audioread(filename2);
    audio2=sdata2(:,1) ;
    audio2 = audio2/max(audio2);

%% 短时傅里叶变换
    p = pspectrum(audio2,fs2,'spectrogram', ...
        'TimeResolution',0.02,'Overlap',75,'Leakage',0.875);
    psum=sum(p,1);
    psumSmooth=smooth(psum,5);
% 查看声谱叠加曲线
    figure;
    plot(psum);

%% 基于阈值的起始点识别
    psumS1=psumSmooth>1.1;
    pind=diff(psumS1,1)>0;
    pind=[0; pind];
    pind=find(pind>0);
% 查看起始点
    figure;
    plot(psumS1)
    hold on
    plot(pind,psumS1(pind),'ro')
    hold off
% Frame计算帧数
   %短时傅里叶移动的步长为0.02秒*0.25，视频每秒30帧
    find = fix(pind*0.25*0.02*30);
% 创建Premiere可读取的XML文件    
    ToPrXML(find,'PrGunTest0114.xml');
