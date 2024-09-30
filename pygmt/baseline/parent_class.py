import pygmt
from pygmt.baseline.cmap_to_cpt import *

class cparent:
  def __init__(self, proj, cpallete, cmap):
    self.proj = proj
    self.cMap = cmap
    
    export_cmap_to_cpt(cpallete, cmap)
  
  def color_bar(self, b1=-1.0, b2=1.0, unit=None, outfile="bar.pdf"):
    bar = pygmt.Figure()
    bar.colorbar(cmap=self.cMap, frame="xg0", position="j-1.1c+w12c/1.5c+h", region=[0,1,0,1])
    bar.text(text=b1,   x=2.585, y=2.10, font="60p,Helvetica", no_clip=True)
    bar.text(text=unit, x=3.000, y=2.10, font="60p,Helvetica", no_clip=True)
    bar.text(text=b2,   x=3.397, y=2.10, font="60p,Helvetica", no_clip=True)
    bar.savefig(outfile)
