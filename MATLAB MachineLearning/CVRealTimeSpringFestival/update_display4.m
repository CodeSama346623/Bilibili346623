function update_display4(obj, event, hImage)
global net counter
% 每5张图像识别一次
if mod(counter,5)==1 
% 显示原始图像
% set(hImage, 'CData',event.Data);
imgOri = event.Data;

%%提取文字
% 色域转换RGB to HSV
imgHSV=rgb2hsv(event.Data);
imgT=imgHSV(:,:,2);
% 背景拉平
imgBG=imgaussfilt(imgT,10);%10 6  5
imgDiff=imgT-imgBG;
% 二值化，填补孔洞
imgBW=imbinarize(imgDiff);
imgBWori=imgBW;
imgBW = imclose(imgBW,strel('disk',5));

%% 提取潜在有效区域的属性（范围、像素面积、像素点位置）
EasterEgg=0;
Pred='None';
hNum=regionprops(imgBW,'BoundingBox','Area','PixelList');
Area= cat(1,hNum.Area);
BBox=cat(1,hNum.BoundingBox);
[hmax,hmind]=sort(Area,'descend');
imgBWlabel=uint8(imgBW*255);
for i=1:length(hmax)
    % 面积小于200的部分不予识别
    if  (Area(hmind(i))>200)
        Swidth = max([BBox(hmind(i),3),BBox(hmind(i),4)]);
        Sstart1 =fix( BBox(hmind(i),1))+1;
        Sstart2 = fix(BBox(hmind(i),2) )+1;
        Swidth1 = BBox(hmind(i),3);
        Swidth2 = BBox(hmind(i),4);        
        SimgGray=imgBWori(Sstart2:(Sstart2+Swidth2-1), Sstart1:(Sstart1+Swidth1-1));        
        % 构造方形的图片
            SimgNew = zeros(Swidth,Swidth);
            if Swidth1<Swidth2
            SimgNew(:,fix((Swidth-Swidth1)/2+1): (fix((Swidth-Swidth1)/2+1)+Swidth1-1))=SimgGray;
            else
            SimgNew(fix((Swidth-Swidth2)/2+1): (fix((Swidth-Swidth2)/2+1)+Swidth2-1),:)=SimgGray;
            end
            % 图片识别
            imgT2=imresize(uint8(SimgNew*255),[28 28]);
            Pred = classify(net, imgT2);
            % 图像中加入标注（‘10’为彩蛋福字标记）
            if Pred~=categorical(cellstr('10'))
            imgBWlabel = insertObjectAnnotation(imgBWlabel, 'rectangle', BBox(hmind(i),:), char(Pred),'FontSize',16);
            imgOri = insertObjectAnnotation(imgOri, 'rectangle', BBox(hmind(i),:), char(Pred),'FontSize',16);
            else
            imgBWlabel = insertObjectAnnotation(imgBWlabel, 'rectangle', BBox(hmind(i),:), 'Fu','FontSize',16,'color','r');
            imgOri = insertObjectAnnotation(imgOri, 'rectangle', BBox(hmind(i),:), 'Fu','FontSize',16,'color','r');
            EasterEgg=1;
            end       
    end% end of
end
% 设置图片显示
set(hImage, 'CData',imgOri);
% 彩蛋激活判断
if EasterEgg==1
    xlabel('码君祝大家新春快乐，福气满满！','Color','r','FontSize',16)
else
    xlabel('')
end

end% End of if Mod

counter=counter+1;
drawnow



