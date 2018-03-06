from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.uix.image import Image

labelStr='''
[b]Kivy Logo![/b]
    by CodeSama@bilibili.com
'''

class TestApp(App):
    def build(self):
        self.title="Kivy Logo"

        layout = GridLayout(cols=1)        
        lab = Label(text=labelStr,markup=True,
                    font_size='30sp',size_hint_y=None, height=100)
        img = Image(source='.\\kivy-logo.png')

        layout.add_widget(lab)
        layout.add_widget(img)
        return layout

TestApp().run()
