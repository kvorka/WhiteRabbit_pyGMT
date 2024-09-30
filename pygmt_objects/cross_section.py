#####################################################
## Python class for generating the cross-sections. ##
## Cartesian projection > proj = "X5c/12c".        ##
## Spherical projection proj = "Pa8c".             ##
#####################################################
from pygmt_objects.baseline.parent_class import *

class csection(cparent):
  
  def cross_section(self, infile, outfile, cB, cT, xanot=None, yanot=None, tgtc=None):
    pygmtfig = pygmt.Figure()
    
    data = numpy.genfromtxt(infile, converters={2: lambda x: float(x) / cB})
    
    if self.proj[0] == "X":
      self.data_to_pygmtfig(pygmtfig, ["WSne",xanot,yanot], cT, data)
      
      #pygmtfig.text(text="0.5", x=0.5, y=-10.0, no_clip=True)
      
      if tgtc != None:
        data = numpy.genfromtxt(tgtc)
        pygmtfig.plot(x=data[:,0], y=data[:,1], pen="3p,black,-")
      
    elif self.proj[0] == "P":
      data[:,0], data[:,1] = data[:,1], data[:,0]
      
      self.data_to_pygmtfig(pygmtfig, ["WSne"], cT, data)
      
      if tgtc != None:
        data = numpy.genfromtxt(tgtc)
        pygmtfig.plot(x=data[:,1], y=data[:,0], pen="3p,black,-")
    
    pygmtfig.savefig(outfile)
