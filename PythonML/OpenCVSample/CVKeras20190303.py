import numpy as np
import cv2
from keras.models import load_model

# 改变图片维度
def changeDim(img):
    img=np.expand_dims(img,axis=2)
    img=np.expand_dims(img,axis=0)
    return img

# 读取模型 
model =load_model('./model01.h5')
# 获取摄像头
cap = cv2.VideoCapture(2)
threshold = 150 #字符分割阈值
# 图像获取，分割，识别，显示
while(True):
    # 读取一帧图像
    ret, frame = cap.read()

    # 图像色域变换
    lab = cv2.cvtColor(frame, cv2.COLOR_BGR2LAB)
    s = lab[:,:,1]
    # 分割字符区域    
    maskOri = cv2.inRange(s,threshold, 255) #分割的中间结果图像
    images,contours,hierarchy = cv2.findContours(maskOri,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)

    # 识别字符
    newmask=frame #识别的最终结果图像
    for cnt in contours:
        #获取矩形区域信息
        x,y,w,h = cv2.boundingRect(cnt)
        width = np.max([h,w])
        # 通过长宽做一次筛选
        if width > 30 and width<150:            
            if h > w:
                left = x+int(w/2)-int(h/2)
                up = y
            else:
                left = x
                up = y+int(h/2)-int(w/2)
            # 显示矩形区域    
            newmask = cv2.rectangle(newmask,(left,up),(left+width,up+width), (0,0,255), 3)
            
            # 分割出矩形区域
            imgTest = s[up:up+width, left:left+width]
            if imgTest.shape[0]>0 and imgTest.shape[1]>0:
                # 识别字符
                imgTest = cv2.resize(imgTest,(28,28),interpolation = cv2.INTER_CUBIC)                
                imgTest[imgTest<threshold] = 0
                imgTest = imgTest/np.max(imgTest[:])                
                imgTest = changeDim(imgTest)
                resTest = np.argmax(model.predict(imgTest))
                # 显示识别结果
                font = cv2.FONT_HERSHEY_SIMPLEX
                if resTest != 10:
                    newmask =  cv2.putText(newmask,str(resTest),(left,up), font, 1,(0,255,255),2,cv2.LINE_AA)
                else:
                    newmask =  cv2.putText(newmask,'Fu',(left,up), font, 1,(0,0,255),2,cv2.LINE_AA)

    # 显示中间结果和识别结果
    cv2.imshow('mask', maskOri)
    cv2.imshow('keypoint',newmask)

    # 按“Q”键退出程序
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 释放摄像头，关闭窗口
cap.release()
cv2.destroyAllWindows()