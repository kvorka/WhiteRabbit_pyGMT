import subprocess
from pygmt_objects.cross_section import csection
from pygmt_objects.surface_plot import csurface

## Create csection object and define the projection and colorpallete (from matplotlib.colors) to be used
csc = csection( proj="X5c/10c", cpallete="coolwarm", cmap="cmap.cpt" )

## Cross sections zonal jet
#csc.color_bar( b1="-0.3", b2="0.3", unit="m/s", outfile="85-bar-vphi.pdf" )
#csc.cross_section( inf="85-mode1-vphi.dat",  outf="85-mode1-vp.pdf",  cB=0.3, cT=1.0, xnt="xf0.5", ynt="ya30", tgt="tgt.dat" )
#csc.cross_section( inf="85-mode2a-vphi.dat", outf="85-mode2a-vp.pdf", cB=0.3, cT=1.0, xnt="xf0.5", ynt="ya30", tgt="tgt.dat" )
#csc.cross_section( inf="85-mode2b-vphi.dat", outf="85-mode2b-vp.pdf", cB=0.3, cT=1.0, xnt="xa0.5f0.5", ynt="ya30", tgt="tgt.dat" )

## Cross section meridional circulation
#csc.color_bar( b1="-8.5", b2="8.5", unit="cm/s", outfile="80-bar-vtht.pdf" )
#csc.cross_section( inf="80-mode1-vtht.dat",  outf="80-mode1-vt.pdf",  cB=0.085, cT=0.6, xnt="xf0.5", ynt="yf30" )
#csc.cross_section( inf="80-mode2a-vtht.dat", outf="80-mode2a-vt.pdf", cB=0.085, cT=0.7, xnt="xf0.5", ynt="yf30" )
#csc.cross_section( inf="80-mode2b-vtht.dat", outf="80-mode2b-vt.pdf", cB=0.085, cT=1.0, xnt="xa0.5f0.5", ynt="yf30" )

## Cross section radial velocity
#csc.color_bar( b1="-2.8", b2="2.8", unit="cm/s", outfile="80-bar-vrad.pdf" )
#csc.cross_section( inf="80-mode1-vrad.dat",  outf="80-mode1-vr.pdf",  cB=0.028, cT=0.6, xnt="xf0.5", ynt="yf30" )
#csc.cross_section( inf="80-mode2a-vrad.dat", outf="80-mode2a-vr.pdf", cB=0.028, cT=0.6, xnt="xf0.5", ynt="yf30" )
#csc.cross_section( inf="80-mode2b-vrad.dat", outf="80-mode2b-vr.pdf", cB=0.028, cT=1.0, xnt="xa0.5f0.5", ynlt="yf30" )

## Create csurface object and define the colorpallete (from matplotlib.colors) to be used
csf = csurface( proj="W180/12", cpallete="coolwarm", cmap="cmap.cpt" )

csf.color_bar( b1="-0.20", b2="0.20", unit="", outfile="85-bar-flux.pdf" )
csf.surface_plot( inf="Ek3-085-mode2b-flux.dat", outf="085-mode2b-fx.pdf", cB=0.20, cT=1.0, tgtn="tgt-n.dat", tgts="tgt-s.dat")

subprocess.run("rm -f cmap.cpt", shell=True)
