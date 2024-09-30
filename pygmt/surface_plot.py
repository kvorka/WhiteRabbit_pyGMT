#######################################################
###  Python class for generating the surface plots. ###
###  Only supported projection is W.                ###
#######################################################
from pygmt.baseline.parent_class import *

class csurface(cparent):
  
  def surface_plot(self, infile, outfile, cB, cT, tgtcn=None, tgtcs=None):
    pygmtfig = pygmt.Figure()
    
    data = numpy.genfromtxt(infile, converters={2: lambda x: float(x) / cB})
    
    self.data_to_pygmtfig(pygmtfig, ["WSne"], cT, data)
    
    if tgtcn != None:
      data = numpy.genfromtxt("tgt-n.dat")
      pygmtfig.plot(x=data[:,0], y=data[:,1], pen="2p,-")
    
    if tgtcs != None:
      data = numpy.genfromtxt("tgt-s.dat")
      pygmtfig.plot(x=data[:,0], y=data[:,1], pen="2p,-")
    
    pygmtfig.savefig(outfile)