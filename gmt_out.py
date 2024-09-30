import subprocess as sb
from pygmt_objects.cross_section import csection
from pygmt_objects.surface_plot import csurface

sb.run("source load_gmt6", shell=True, executable="/bin/bash")

## Create csection object and define the projection and colorpallete (from matplotlib.colors) to be used
csc = csection( proj="X5c/10c", cpallete="coolwarm", cmap="cmap.cpt" )

## Cross sections zonal jet
#csc.color_bar( b1="-0.3", b2="0.3", unit="m/s", outfile="85-bar-vphi.pdf" )
#csc.cross_section( infile="Ek3-085-mode1-vphi.dat",  outfile="085-mode1-vp.pdf",  cB=0.3, cT=1.0, xanot="xf0.5", yanot="ya30", tgtc="tgt.dat" )
#csc.cross_section( infile="Ek3-085-mode2a-vphi.dat", outfile="085-mode2a-vp.pdf", cB=0.3, cT=1.0, xanot="xf0.5", yanot="ya30", tgtc="tgt.dat" )
#csc.cross_section( infile="Ek3-085-mode2b-vphi.dat", outfile="085-mode2b-vp.pdf", cB=0.3, cT=1.0, xanot="xa0.5f0.5", yanot="ya30", tgtc="tgt.dat" )

## Cross section meridional circulation
#csc.color_bar( b1="-8.5", b2="8.5", unit="cm/s", outfile="80-bar-vtht.pdf" )
#csc.cross_section( infile="Ek3-080-mode1-vtht.dat",  outfile="080-mode1-vt.pdf",  cB=0.085, cT=0.6, xanot="xf0.5", yanot="yf30" )
#csc.cross_section( infile="Ek3-080-mode2a-vtht.dat", outfile="080-mode2a-vt.pdf", cB=0.085, cT=0.7, xanot="xf0.5", yanot="yf30" )
#csc.cross_section( infile="Ek3-080-mode2b-vtht.dat", outfile="080-mode2b-vt.pdf", cB=0.085, cT=1.0, xanot="xa0.5f0.5", yanot="yf30" )

## Cross section radial velocity
#csc.color_bar( b1="-2.8", b2="2.8", unit="cm/s", outfile="80-bar-vrad.pdf" )
#csc.cross_section( infile="Ek3-080-mode1-vrad.dat",  outfile="080-mode1-vr.pdf",  cB=0.028, cT=0.6, xanot="xf0.5", yanot="yf30" )
#csc.cross_section( infile="Ek3-080-mode2a-vrad.dat", outfile="080-mode2a-vr.pdf", cB=0.028, cT=0.6, xanot="xf0.5", yanot="yf30" )
#csc.cross_section( infile="Ek3-080-mode2b-vrad.dat", outfile="080-mode2b-vr.pdf", cB=0.028, cT=1.0, xanot="xa0.5f0.5", yanot="yf30" )

## Create csurface object and define the colorpallete (from matplotlib.colors) to be used
csf = csurface( proj="W180/12", cpallete="coolwarm", cmap="cmap.cpt" )

csf.color_bar( b1="-0.20", b2="0.20", unit="", outfile="85-bar-flux.pdf" )
csf.surface_plot( infile="Ek3-085-mode2b-flux.dat", outfile="085-mode2b-fx.pdf", cB=0.20, cT=1.0, tgtcn="tgt-n.dat", tgtcs="tgt-s.dat")

sb.run("rm -f cmap.cpt", shell=True, executable="/bin/bash")
