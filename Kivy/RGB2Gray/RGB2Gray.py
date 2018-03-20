import matplotlib
matplotlib.use('module://kivy.garden.matplotlib.backend_kivy')
import matplotlib.pyplot as plt

from PIL import Image
import numpy as np

from kivy.garden.matplotlib.backend_kivyagg import FigureCanvas,FigureCanvasKivyAgg

from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.button import Button
from kivy.uix.label import Label

from kivy.uix.floatlayout import FloatLayout
from kivy.factory import Factory
from kivy.properties import ObjectProperty
from kivy.uix.popup import Popup
import os

fig,ax=plt.subplots()
fig2,ax2=plt.subplots()


class LoadDialog(FloatLayout):
    load = ObjectProperty(None)
    cancel = ObjectProperty(None)
    cwdir=ObjectProperty(None)
    
class MyApp(App):
    
    
    def build(self):
        self.title='RGB to Grayscale'
        box = GridLayout(cols=2)
        
        label1=Label(text='[b][color=ff0000]R[/color][color=00ff00]G[/color][color=0000ff]B[/color] image[/b]',
                     font_size='20sp',size_hint_y=None, height=50,markup=True)
        label2=Label(text='[b]Grayscale image[/b]',
                     font_size='20sp',size_hint_y=None, height=50,markup=True)

        box.add_widget(label1)
        box.add_widget(label2)
        
        box.add_widget(FigureCanvasKivyAgg(fig))
        box.add_widget(FigureCanvasKivyAgg(fig2))
        
        openBtn=Button(text='Open',size_hint_y=None, height=50)
        openBtn.bind(on_release=self.show_load)
        box.add_widget(openBtn)
                
        grayBtn=Button(text='RGB2Gray',size_hint_y=None, height=50)
        grayBtn.bind(on_release=self.gray_image)
        box.add_widget(grayBtn)

        self.imgG=None
        return box
    
    

    def show_load(self,obj):
        content = LoadDialog(load=self.load, cancel=self.dismiss_popup,cwdir=os.getcwd())        
        self._popup = Popup(title="Load file", content=content,size_hint=(0.9, 0.9))
        self._popup.open()

    def load(self, path, filename):
        if filename:
            img=Image.open(os.path.join(path, filename[0]))
            ax.imshow(np.array(img))
            fig.canvas.draw()
            self.dismiss_popup()
            self.imgG=img
            
    def dismiss_popup(self):
        self._popup.dismiss()

    def gray_image(self,obj):
        if self.imgG!=None:
            img=self.imgG.convert("L")            
            ax2.imshow(np.array(img),cmap="gray")
            fig2.canvas.draw()

Factory.register('LoadDialog', cls=LoadDialog)
MyApp().run()
