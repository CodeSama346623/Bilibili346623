javaaddpath('core-3.3.2.jar');
javaaddpath('javase-3.3.2.jar');

vidobj = videoinput('winvideo');
vidRes = vidobj.VideoResolution;

f = figure('Visible', 'off');
imageRes = fliplr(vidRes);
hImage = imshow(zeros(imageRes));
axis image;
setappdata(hImage,'UpdatePreviewWindowFcn',@update_display);

dbtype('update_display.m')
preview(vidobj, hImage);
pause(60);
stoppreview(vidobj);
delete(f);
delete(vidobj)
clear vidobj