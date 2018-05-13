
%% 获取区域内的灰度值
function ireg=iregion(img,i,j,dim)
tempt=img(i:(i+dim-1),j:(j+dim-1));
tempt=tempt(:);
ireg=mean(tempt);
end