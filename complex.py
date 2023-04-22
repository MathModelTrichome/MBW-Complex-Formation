try:
    from Tkinter import *
except ImportError:
    from tkinter import *
    
import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import sys
import os

class graph():
    

    def __init__(self, start=(1,1,1,1)):
        filename = 'data.csv';
        try:
            base_path = sys._MEIPASS
        except Exception:
            base_path = os.path.abspath(".")

        data_location = os.path.join(base_path, filename)
        self.data = np.genfromtxt(data_location, delimiter=',')
        self.indices = self.data[:, :4]
        self.complexes = self.data[:, 4:]

        self.possible_values = np.array([0, 0.25, 1, 2, 3, 4])
        self.current_values = np.array(start, dtype=float)
        self.labels = (
            'GL3-GL1','GL3-TTG1','GL3-TRY','GL3-GL3','GL3-GL1-TTG1','GL3-TTG1-TRY',
            'GL1-GL3-GL3','TTG1-GL3-GL3','TRY-GL3-GL3','TTG1-GL1-GL3-GL3','TRY-TTG1-GL3-GL3',
            'GL1-GL3-GL3-TTG1','GL1-GL3-GL3-TRY','TTG1-GL3-GL3-TRY','GL1-GL3-GL3-GL1','TTG1-GL3-GL3-TTG1',
            'TRY-GL3-GL3-TRY','GL1-TTG1-GL3-GL3-GL1','GL1-TTG1-GL3-GL3-TTG1', 'GL1-GL3-GL3-TTG1-TRY',
            'GL1-TTG1-GL3-GL3-TRY','TTG1-TRY-GL3-GL3-TRY','TRY-TTG1-GL3-GL3-TTG1','GL1-TTG1-GL3-GL3-TTG1-GL1',
            'TTG1-TRY-GL3-GL3-TRY-TTG1','GL1-TTG1-GL3-GL3-TTG1-TRY'
            )
        self.root = Tk()
        self.fig = plt.Figure()#facecolor=(1,1,1))
        self.canvas = FigureCanvasTkAgg(self.fig, self.root)
        self.canvas.get_tk_widget().pack(side=TOP, fill=BOTH, expand=1)
        self.ax = self.fig.add_subplot(111)
        self.fig.subplots_adjust(bottom=0.1)
        #plt.style.use('seaborn')
        self.y_pos = np.arange(len(self.labels))
        
        self.sliders = []
        labels = 'GL1:GL3', 'TTGL1:GL3', 'TRY:GL3'
        for i, label in enumerate(labels):
            slider = Scale(self.root, label=label, 
                           from_=self.possible_values.min(), to=self.possible_values.max(),
                           length=200, resolution=0.01, orient="horizontal",
                           command=self.limit_slider(i))
            slider.set(1)
            slider.pack(padx=5, pady=10, side='left')

            self.sliders.append(slider)

    def limit_slider(self, idx):
        def check(value):
            value = float(value)
            value = self.possible_values[np.argmin(np.abs(self.possible_values - value))]
            self.sliders[idx].set(value)
            self.update(idx, float(value))
        return check

    def update(self, idx, value):
        # lazy update if slider was moved but not changed
        if self.current_values[idx] != value:
            self.current_values[idx] = value
            self.draw()

    def draw(self):
    	opacity = 0.5
    	idx = np.nonzero((self.indices == self.current_values).all(axis=1))
    	complx = np.squeeze(self.complexes[idx])
    	self.ax.clear()
    	sns.barplot(complx, self.y_pos, ax=self.ax, orient='h', palette="Spectral")
    	sns.despine()

    	for p in self.ax.patches:
            if p.get_width() <= 0.0001:
                self.ax.annotate("0%", (p.get_x() + p.get_width(), p.get_y() + 1.6),
                xytext=(5, 10), textcoords='offset points', size=9)
            elif p.get_width() < 1:
                self.ax.annotate("<1%", (p.get_x() + p.get_width(), p.get_y() + 1.6),
                xytext=(5, 10), textcoords='offset points', size=9)
            else:
                self.ax.annotate("%.0f%%" % p.get_width(), (p.get_x() + p.get_width(), p.get_y() + 1.6),
                xytext=(5, 10), textcoords='offset points', size=9)


    	self.ax.set_yticklabels(self.labels)
    	self.ax.set_yticks(self.y_pos)
    	self.ax.set_xlabel("%")
    	self.canvas.draw()
    	self.fig.tight_layout()

    def run(self):
        self.draw()
        self.root.mainloop()

G = graph()
G.run()

