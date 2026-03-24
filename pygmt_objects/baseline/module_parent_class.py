#######################################################
## Python module supporting the parent_class.py      ##
#######################################################
import numpy             # type: ignore
import matplotlib.pyplot # type: ignore

def get_data(fname, rescale=1, revert=False):
  
  data = numpy.genfromtxt( fname=fname, 
                           converters={ 2: lambda x: float(x) / rescale } )
  
  if revert: data[:,0], data[:,1] = data[:,1], data[:,0]

  return data

def get_step(arr):
  
  x0 = arr[0]
  
  for x in arr[1:]:
    if (x != x0):
      step = abs(x-x0)
      break
  
  return step

def export_cmap_to_cpt(cpallete, cfile, cmin=None, cmax=None, **kwargs):
  N = 255

  cmap = matplotlib.pyplot.get_cmap(cpallete, N)
  
  b = numpy.array(kwargs.get("B", cmap(0.)))
  f = numpy.array(kwargs.get("F", cmap(1.)))
  
  na = numpy.array(kwargs.get("N", (0,0,0))).astype(float)
  
  ext = (numpy.c_[b[:3],f[:3],na[:3]].T*255).astype(int)
  extstr = "B {:3d} {:3d} {:3d}\nF {:3d} {:3d} {:3d}\nN {:3d} {:3d} {:3d}"
  
  cols = (cmap(numpy.linspace(0.,1.,N))[:,:3]*255).astype(int)
  
  if cmin != None and cmax != None:
    vals = numpy.linspace(cmin,cmax,N)
  else:
    vals = numpy.linspace(-1,+1,N)
  
  numpy.savetxt( cfile, 
                 numpy.c_[vals[:-1],cols[:-1],vals[1:],cols[1:]], 
                 fmt      = "%e %3d %3d %3d %e %3d %3d %3d", 
                 header   = "# COLOR_MODEL = RGB", 
                 footer   = extstr.format(*list(ext.flatten())), 
                 comments = "" )