from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.uix.image import Image, AsyncImage
import PIL

gifFilename=['.\\Gif2.gif','.\\Gif3.gif','.\\Gif4.gif','.\\Gif0.gif']

class MyAsyncImage(AsyncImage):

    def __init__(self,**args):
        self.filelist=args['filelist']
        self.fnumberlist=list()
        self.animeDelay=list()
        for i in range(0,len(self.filelist)):
            self.fnumberlist.append(self.getFrameNumber(self.filelist[i]))
            self.animeDelay.append(self.getAnimeDelay(self.filelist[i]))
        # frame counter for a single gif file
        self.frame_counter=0
        self.frame_number=self.fnumberlist[0]
        # imagelist index
        self.img_pointer=0
        # image file handle
        self.imgloading=None
        # flag:one file have been loaded
        self.loadingEnd=False
        # flag:all files have been loaded
        self.loadingloop=False
        
        AsyncImage.__init__(self,source=self.filelist[0],anim_delay=self.animeDelay[0])

    def on_texture(self, instance, value):
        if not self.loadingEnd:
            if self.frame_counter==0:
                self.imgloading=self._coreimage.image
                self.frame_counter += 1
            else:
                if self._coreimage.image!=self.imgloading:
                    self.loadingEnd=True
                    self.frame_counter=0
                else:
                    self.frame_counter += 1                    
        else:
            if  self.frame_counter == (self.frame_number-1):                
                if self.img_pointer<(len(self.filelist)-1):
                        self.img_pointer+=1                        
                else:
                    self.img_pointer=0
                    self.loadingloop=True
                    
                if self.loadingloop==False:
                    self.loadingEnd=False      

                self.on_changefile()
                
            else:               
                self.frame_counter += 1      

    def on_changefile(self):
        self.frame_counter=0
        self.frame_number=self.fnumberlist[self.img_pointer]
        self.anim_delay=self.animeDelay[self.img_pointer]
        self.source=self.filelist[self.img_pointer]       

    def getFrameNumber(self,filename):
        img=PIL.Image.open(filename)
        counter=0
        try:
            while(True):
                img.seek(img.tell()+1)
                counter+=1            
        except EOFError:
            if counter==0:
                return 1
            else:
                return counter
            
    def getAnimeDelay(self,filename):
        return PIL.Image.open(filename).info['duration']/1000.0

class TestApp(App):
    def build(self):
        self.title="Kivy Gif Slide"
        layout = GridLayout(cols=1)
        label=Label(text="Kivy Gif Slide",font_size='30sp',size_hint_y=None, height=100)
        layout.add_widget(label)
        images = MyAsyncImage(filelist=gifFilename)
        layout.add_widget(images)
        return layout

TestApp().run()

