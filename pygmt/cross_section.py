from pygmt.baseline.parent_class import *

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
      ## This needs to be figured out by a function
      datahelp  = data[:,0]
      data[:,0] = data[:,1]
      data[:,1] = datahelp
      ## Everything else is just fine
      
      self.data_to_pygmtfig(pygmtfig, ["WSne"], cT, data)
      
      if tgtc != None:
        data = numpy.genfromtxt(tgtc)
        pygmtfig.plot(x=data[:,1], y=data[:,0], pen="3p,black,-")
    
    pygmtfig.savefig(outfile)