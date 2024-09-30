import pygmt
from pygmt_objects.baseline.module_parent_class import *

class cparent:
  
  def __init__(self, proj, cpallete, cmap):
    pygmt.config( FONT_ANNOT_PRIMARY = 23, 
                  MAP_ANNOT_OFFSET = "7p",
                  MAP_TICK_LENGTH_PRIMARY = 0.10, 
                  MAP_TICK_LENGTH_SECONDARY = 1.0 )
    
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
  
  def data_to_pygmtfig(self, pygmtfig, frame, cT, data):
    pygmt.makecpt( cmap = self.cMap, 
                   series = [-cT,cT], 
                   background = True )
    
    region = [ data[:,0].min(), data[:,0].max() ,
               data[:,1].min(), data[:,1].max() ]
    
    spacing = [ get_step(data[:,0]) ,
                get_step(data[:,1]) ]
    
    grid = pygmt.xyz2grd( x = data[:,0],
                          y = data[:,1],
                          z = data[:,2],
                          spacing = spacing,
                          region = region )
    
    pygmtfig.grdimage( region = region,
                       projection = self.proj,
                       frame = frame,
                       grid = grid )
