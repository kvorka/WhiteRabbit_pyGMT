from pygmt.baseline.parent_class import *

class csurface(cparent):
  def data_to_pygmtfig(self, frame, cB, cT, infile, outfile, tgtcn=None, tgtcs=None):
    pygmtfig = pygmt.Figure()
    
    pygmt.config( FONT_ANNOT_PRIMARY=23, 
                  MAP_ANNOT_OFFSET="7p",
                  MAP_TICK_LENGTH_PRIMARY=0.10, 
                  MAP_TICK_LENGTH_SECONDARY=1.0 )
    
    pygmt.makecpt(cmap=self.cMap, series=[-cT,cT], background=True)
    
    data = numpy.genfromtxt(infile)
    
    min0 = data[:,0].min()
    max0 = data[:,0].max()
    min1 = data[:,1].min()
    max1 = data[:,1].max()
    
    for x,y in zip(data[:,0],data[1:,0]):
      if (x != y):
        step0 = y-x
        break
    
    for x,y in zip(data[:,1],data[1:,1]):
      if (x != y):
        step1 = y-x
        break
    
    for i in range(len(data[:,2])):
      data[i,2] = data[i,2] / cB
    
    region = [min0,max0,min1,max1]
    grid   = pygmt.xyz2grd(x=data[:,0], y=data[:,1], z=data[:,2], spacing=[step0,step1], region=region)
    
    pygmtfig.grdimage(region=region, projection=self.proj, frame=frame, grid=grid)
    
    if tgtcn != None:
      data = numpy.genfromtxt("tgt-n.dat")
      pygmtfig.plot(x=data[:,0], y=data[:,1], pen="2p,-")
    
    if tgtcs != None:
      data = numpy.genfromtxt("tgt-s.dat")
      pygmtfig.plot(x=data[:,0], y=data[:,1], pen="2p,-")
    
    pygmtfig.savefig(outfile)
  
  def surface_plot(self, infile, outfile, cB, cT, tgtcn=None, tgtcs=None):
    self.data_to_pygmtfig(["WSne"], cB, cT, infile, outfile, tgtcn, tgtcs)