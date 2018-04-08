import random
import json
import urlfetch
from kivy.graphics import *
from kivy.app import App
from kivy.uix.widget import Widget
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.core.window import Window
from kivy.uix.image import AsyncImage
from kivy.clock import Clock

# to get url of CodeSama's logo
def getMyInfo():
    hdr={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36',
         'Host':'space.bilibili.com','Origin':'https://space.bilibili.com','Referer':'https://space.bilibili.com/9579763/'}
    url='https://space.bilibili.com/ajax/member/GetInfo'
    dat={'mid':'9579763'}
    res=urlfetch.post(url,headers=hdr,data=dat)
    if res.status==200:
        resstr=res.content
        #print resstr
        strjson=json.loads(resstr)
        return strjson['data']
    else:
        return []

# to get follower's logo
def getSevenDayRank():
    hdr={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36','Host':'api.live.bilibili.com'}
    url='https://api.live.bilibili.com/rankdb/v1/RoomRank/webSevenRank?roomid=346623&ruid=9579763'
    res=urlfetch.fetch(url,headers=hdr)
    if res.status==200:
        resstr=res.content
        #print (resstr)
        strjson=json.loads(resstr)
        return strjson['data']['list']
    else:
        return []

# testing images
'''applefaceUrl=['https://i1.hdslb.com/bfs/face/76f04dc6622ab95b5ff5044660ef9b2d2e0e9adf.jpg','https://i2.hdslb.com/bfs/face/5418b6517e83b0175adf4df4d85cdb8fb4096019.jpg',
                'https://i2.hdslb.com/bfs/face/cd7541d9cf9ffcd6d32ada14470a9d35b4e24f4d.jpg','https://i2.hdslb.com/bfs/face/25f28666da932d856d0f510f406a00e5206966fe.jpg'
]'''
#loading logo of codesama
codesama=getMyInfo()
snakeface=AsyncImage(source=codesama['face'])

# laoding logos of followers
applefaceUrl=list()
sRank=getSevenDayRank()
for single in sRank:
    applefaceUrl.append(single['face'])
applefacelist=list()
for i in range(0,len(applefaceUrl)):
    applefacelist.append(AsyncImage(source=applefaceUrl[i]))

# background: chessboard
class self_bg(Widget):
    def __init__(self):
        Widget.__init__(self,size=(600,600),size_hint=(None, None))
        with self.canvas:
            for j in range(0,10):
                flag=j % 2
                for i in range(0,10):
                    if i % 2==flag:
                        Color(111/255.0, 159/255.0, 216/255.0)
                        Rectangle(pos=(60*i,60*j),size=(60,60))
                    else:
                        Color(175/255.0, 201/255.0, 233/255.0)
                        Rectangle(pos=(60*i,60*j),size=(60,60))

# snake head: automove interval 1s
class self_snake_head(Widget):
    def __init__(self,filename,position):
        Widget.__init__(self,
        size=(60,60),pos=position)
        self.filename=filename
        self.Endflag=False
        Clock.schedule_interval(self.clockCallback, 1)
        with self.canvas:
            Color(0,1,0,0.3)
            print (self.pos,self.size)
            self.bg_ellipse=Ellipse(pos=(self.x-5,self.y-5),size=(self.width+10,self.height+10),
            angle_start=0,angle_end=360)

            Color(1,1,1,1)
            self.bg_logo=Ellipse(pos=(self.x+3,self.y+3),size=(self.width-6,self.height-6),
            angle_start=0,angle_end=360,texture=filename.texture)
        self.bind(pos=self.redraw)

    def redraw(self,instance,value):       
        self.Endflag=(value[0],value[1]) in rootApp.snakepos            
        condition2=value[0]>=0 and value[0]<600 and value[1]>=0 and value[1]<600
        if condition2  and not self.Endflag:
            self.bg_ellipse.pos=(self.x-5,self.y-5)
            self.bg_logo.pos=(self.x+3,self.y+3)
            self.bg_logo.texture=self.filename.texture
        else:
            self.Endflag=True
            Clock.unschedule(self.clockCallback)
            print("Game Over")
    def clockCallback(self,dt):        
        self.pos=(self.x+rootApp.snakeDir[0],self.y+rootApp.snakeDir[1])
        rootApp.snakepos.append((self.x,self.y))
        refresh_snakelist()

# snake tail
class self_snake_tail(Widget):
    def __init__(self,filename,position):
        Widget.__init__(self,
        size=(60,60),pos=position)
        self.filename=filename
        self.Endflag=False
        with self.canvas:
            Color(1,1,1)
            print (self.pos,self.size)
            self.bg_ellipse=Ellipse(pos=self.pos,size=self.size,
            angle_start=0,angle_end=360)
            self.bg_logo=Ellipse(pos=(self.x+3,self.y+3),size=(self.width-6,self.height-6),
            angle_start=0,angle_end=360,texture=filename.texture)
        self.bind(pos=self.redraw)
    def redraw(self,instance,value):
        self.bg_ellipse.pos=self.pos
        self.bg_logo.pos=(self.x+3,self.y+3)
        self.bg_logo.texture=self.filename.texture

# to refresh the number and position of snake tails
def refresh_snakelist():
    if rootApp.snake.x-rootApp.apple.x==0 and rootApp.snake.y-rootApp.apple.y==0:
        addsnake=self_snake_tail(applefacelist[rootApp.apple.applefaceindex], 
        position=(rootApp.snakepos[-(len(rootApp.snakelist)+2)][0],rootApp.snakepos[-(len(rootApp.snakelist)+2)][1]))
        rootApp.snakelist.append(addsnake)
        rootApp.layout.add_widget(addsnake)
        print (len(rootApp.snakelist),-(len(rootApp.snakelist)+2))

        rootApp.apple.opacity=0
        rootApp.apple.appleFlag=True
        rootApp.label.text=str(len(rootApp.snakelist)+1)
    else:
        rootApp.snakepos.pop(0)    
    for i in range(0,len(rootApp.snakelist)):
            rootApp.snakelist[i].pos=(rootApp.snakepos[-(i+2)][0],rootApp.snakepos[-(i+2)][1])

# apple at random position, reloading time 3s
class self_apple(Widget):
    def __init__(self):
        Widget.__init__(self,
        size=(60,60),pos=(2*60,2*60))
        self.appleFlag=False
        self.applefaceindex=0
        Clock.schedule_interval(self.AppleclockCallback,3)

        with self.canvas:
            Color(1,0,0,0.5)
            print (self.pos,self.size)
            self.bg_ellipse=Ellipse(pos=(self.x-5,self.y-5),size=(self.width+10,self.height+10),
            angle_start=0,angle_end=360)
            Color(1,1,1,1)
            self.bg_logo=Ellipse(pos=(self.x+5,self.y+5),size=(self.width-10,self.height-10),
            angle_start=0,angle_end=360,texture=applefacelist[0].texture)

    def AppleclockCallback(self,dt):
        if self.appleFlag:
            applex=random.randint(0, 10-1)*60
            appley=random.randint(0, 10-1)*60
            applefaceindex=random.randint(0, len(applefacelist)-1)
            self.applefaceindex=applefaceindex
            appleface=applefacelist[applefaceindex]
            self.opacity=1
            self.bg_logo.texture=appleface.texture
            self.pos=(applex,appley)
            self.bg_ellipse.pos=(self.x-5,self.y-5)
            self.bg_logo.pos=(self.x+5,self.y+5)
            self.appleFlag=False

# mainframe: add elements and keyboard listener
class TestApp(App):
    def build(self):
        self.title="Kivy snake"
        
        layout=self_bg()
        self.snake=self_snake_head(filename=snakeface,position=(4*60,4*60))
        layout.add_widget(self.snake)
        
        self.snakelist=list()
        self.snakeDir=[0,0]
        self.snakepos=list()
        self.snakepos.append((self.snake.x,self.snake.y))
        
        self.apple=self_apple()
        layout.add_widget(self.apple)
        self.layout=layout
        
        self.keyboard=Window.bind(on_key_down=self.key_action)
        

        layoutAll=GridLayout(cols=2)
        layoutAll.add_widget(layout)
        label=Label(text='1',font_size='40sp')
        layoutAll.add_widget(label)
        self.label=label
        Clock.schedule_once(self.texture_update,5)       
        return layoutAll

    def key_action(self,*args):
        if not self.snake.Endflag:
            vel=60
            if args[1]==276:
                print ("left")
                self.snake.x-=vel
                self.snakepos.append((self.snake.x,self.snake.y))
                self.snakeDir=[-vel,0]
                refresh_snakelist()
            elif args[1]==275:
                print ("right")
                self.snake.x+=vel
                self.snakepos.append((self.snake.x,self.snake.y))
                self.snakeDir=[vel,0]
                refresh_snakelist()
            elif args[1]==274:
                print ("down")
                self.snake.y-=vel
                self.snakepos.append((self.snake.x,self.snake.y))
                self.snakeDir=[0,-vel]
                refresh_snakelist()
            elif args[1]==273:
                print ("up")
                self.snake.y+=vel
                self.snakepos.append((self.snake.x,self.snake.y))
                self.snakeDir=[0,vel]
                refresh_snakelist()
    def texture_update(self,dt):
        self.snake.bg_logo.texture =snakeface.texture
        self.apple.bg_logo.texture =applefacelist[0].texture    

rootApp=TestApp()
rootApp.run()
