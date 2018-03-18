from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.uix.image import Image, AsyncImage
##from kivy.core.window import Keyboard
from kivy.core.window import Window

# keycode
# https://kivy.org/docs/_modules/kivy/core/window.html


gifFilename=[".\\Gif2.gif",".\\Gif3.gif",".\\Gif4.gif"]
giflistlen=len(gifFilename)


class TestApp(App):
    def build(self):
        self.title="Kivy Logo"
        self.gifindexnow=0       
        
        layout = GridLayout(cols=1)        
        self.lab = Label(text=gifFilename[self.gifindexnow],markup=True,
                    font_size='30sp',size_hint_y=None, height=100)
        self.img = AsyncImage(source=gifFilename[self.gifindexnow],anim_delay=30/1000)
        
        layout.add_widget(self.lab)
        layout.add_widget(self.img)

        Window.bind(on_key_up=self.key_action)

        return layout
    def key_action(self,*args):
##        print ("got a key event: %s" % list(args))
##        print (args[1],Keyboard().keycode_to_string(args[1]))
        print (self.gifindexnow)
        if args[1]==276:
            print ("left")
            if self.gifindexnow>=1:
                self.gifindexnow-=1
                self.img.source=gifFilename[self.gifindexnow]                
            else:
                self.gifindexnow=giflistlen-1
                self.img.source=gifFilename[self.gifindexnow]                        
        elif args[1]==275:
            print ("right")
            if self.gifindexnow<=(giflistlen-2):
                self.gifindexnow+=1
                self.img.source=gifFilename[self.gifindexnow]                
            else:
                self.gifindexnow=0
                self.img.source=gifFilename[self.gifindexnow]
        self.lab.text=gifFilename[self.gifindexnow]
        print (self.gifindexnow)
    

TestApp().run()

