#####################################################################################################
## Python class for generating the spherical maps. Only "W" projection is needed (and supported).  ##
## The input file needs to be written such that phi goes first and then theta. Both of the follow- ##
## ing files are fine (but not their mutant)                                                       ##
## phi1, theta1, value11      |      phi1, theta1, value11                                         ##
## phi2, theta1, value12      |      phi1, theta2, value21                                         ##
## phi3, theta1, value13      |      phi1, theta3, value31                                         ##
##         ...                |              ...                                                   ##
#####################################################################################################
from pygmt_objects.baseline.parent_class import *

class csurface(cparent):
  
  def surface_plot(self, inf, outf, cB, cT, tgtn=None, tgts=None):
    fig = pygmt.Figure()
    
    self.data_to_pygmtfig(fig, ["WSne"], cT, get_data(fname=inf, rescale=cB))
    
    if tgtn != None: fig.plot(data = numpy.genfromtxt("tgt-n.dat"), pen="2p,-")
    if tgts != None: fig.plot(data = numpy.genfromtxt("tgt-s.dat"), pen="2p,-")
    
    fig.savefig(outf)
