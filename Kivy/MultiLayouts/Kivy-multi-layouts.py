from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.image import AsyncImage
from kivy.uix.label import Label
from kivy.uix.button import Button


class LayoutTest1(GridLayout):
    def __init__(self):        
        GridLayout.__init__(self,cols=1)
        label=Label(text="Kivy Layout1",font_size='30sp',
                    size_hint_y=None, height=100)
        self.add_widget(label)
        gifimg=AsyncImage(source=".\\Gif0.gif",anim_delay=30/1000)
        self.add_widget(gifimg)
        
        btn=Button(text="switch to Layout 2",
                   size_hint_y=None, height=100)
        btn.bind(on_press=self.changeLayout)
        self.add_widget(btn)
    def changeLayout(self,instance):
        approot.root.clear_widgets()
        approot.root.add_widget(LayoutTest2())        
        
class LayoutTest2(GridLayout):
    def __init__(self):        
        GridLayout.__init__(self,cols=3)
        self.add_widget(Label(text="Layout 2",font_size='30sp',
                              size_hint_x=None, width=150))
        gifimg=AsyncImage(source=".\\Gif1.gif",anim_delay=30/1000)
        self.add_widget(gifimg)
        
        btn=Button(text="switch to Layout 1",
                   size_hint_x=None, width=150)
        btn.bind(on_press=self.changeLayout)
        self.add_widget(btn)
    def changeLayout(self,instance):
        approot.root.clear_widgets()
        approot.root.add_widget(LayoutTest1())    

class TestApp(App):
    def build(self):
        self.title="Kivy Multiple Layouts"
        return LayoutTest1()
    
approot=TestApp()
approot.run()

