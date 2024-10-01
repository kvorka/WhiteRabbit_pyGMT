###############################################################################################
## Python class for generating the cross-sections. Cartesian projection is proj = "X5c/12c". ##
## Spherical projection is proj = "Pa8c". The input file needs to be written such that the   ##
## radial coordinate is first on each line, i.e. "r, theta, value". Both of the following    ##
## files are fine (but not their mutant)                                                     ##
## r1, theta1, value11      |      r1, theta1, value11                                       ##
## r2, theta1, value12      |      r1, theta2, value21                                       ##
## r3, theta1, value13      |      r1, theta3, value31                                       ##
##       ...                |            ...                                                 ##
###############################################################################################
from pygmt_objects.baseline.parent_class import *

class csection(cparent):
  
  def cross_section(self, inf, outf, cB, cT, xnt=None, ynt=None, tgt=None):
    fig = pygmt.Figure()
    
    if self.proj[0] == "X":
      self.data_to_pygmtfig(fig, ["WSne",xnt,ynt], cT, get_data(fname=inf, rescale=cB))
      if tgt != None: fig.plot( data=numpy.genfromtxt(tgt), pen="3p,black,-")
      #fig.text(text="0.5", x=0.5, y=-10.0, no_clip=True)
      
    elif self.proj[0] == "P":
      self.data_to_pygmtfig(fig, ["WSne"], cT, get_data(fname=inf, rescale=cB, revert=True))
      if tgt != None: fig.plot(data=numpy.genfromtxt(tgt), pen="3p,black,-")
    
    fig.savefig(outf)
