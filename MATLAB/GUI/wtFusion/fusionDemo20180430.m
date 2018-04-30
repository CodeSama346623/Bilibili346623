% 读取图片1
x1 = rgb2gray(imread('xixi.jpg'));
%人脸识别，人脸区域bboxes1:[x,y,width,height]
faceDetector = vision.CascadeObjectDetector;
bboxes1 = step(faceDetector, x1);
bimg1=x1(bboxes1(2):(bboxes1(2)+bboxes1(4)),bboxes1(1):(bboxes1(1)+bboxes1(3)) );
% 构造人脸识别结果
IFaces1 = insertObjectAnnotation(x1, 'rectangle', bboxes1, 'Face');
figure, imshow(IFaces1), title('Detected faces');


x2 = rgb2gray(imread('kexi.jpg'));
faceDetector = vision.CascadeObjectDetector;
bboxes2 = step(faceDetector, x2);
bimg2=x2(bboxes2(2):(bboxes2(2)+bboxes2(4)),bboxes2(1):(bboxes2(1)+bboxes2(3)) );
IFaces2 = insertObjectAnnotation(x2, 'rectangle', bboxes2, 'Face');
figure, imshow(IFaces2), title('Detected faces');

%图片缩放
bimg1=imresize(bimg1,[size(bimg2,1),size(bimg2,2)]);
%图片融合
out = wtfusion(bimg2,bimg1,2,'db1');
%放回原图
x3=x2;
x3(bboxes2(2):(bboxes2(2)+bboxes2(4)),bboxes2(1):(bboxes2(1)+bboxes2(3)))=out;

figure;
subplot(1,3,1);imshow(x1);title('xixi');
subplot(1,3,2);imshow(x2);title('kexi');
subplot(1,3,3);imshow(x3);title('基于小波变换的图像融合');