%读取灰度图片
original=imread('scene.pgm');
distorted=imread('book.pgm');

% 特征提取
% ptsOriginal  = detectSURFFeatures(original);
% ptsDistorted = detectSURFFeatures(distorted);
ptsOriginal  = detectBRISKFeatures(original,'MinContrast',0.01);
ptsDistorted = detectBRISKFeatures(distorted,'MinContrast',0.01);

[featuresOriginal,validPtsOriginal] = ...
            extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = ...
            extractFeatures(distorted,ptsDistorted);

%特征匹配        
indexPairs = matchFeatures(featuresOriginal,featuresDistorted,'MatchThreshold',50,'MaxRatio',0.8);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

figure
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted)
title('Candidate matched points (including outliers)')

% 计算几何变换
[tformTotal,inlierDistortedXY,inlierOriginalXY] = ...
    estimateGeometricTransform(matchedDistorted,...
        matchedOriginal,'similarity');

figure
showMatchedFeatures(original,distorted,inlierOriginalXY,inlierDistortedXY)
title('Matching points (inliers only)')
legend('ptsOriginal','ptsDistorted')

%应用几何变换
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tformTotal,'OutputView',outputView);

figure;
imshowpair(original,recovered,'montage')

