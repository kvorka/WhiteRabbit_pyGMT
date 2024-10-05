import subprocess
from pygmt_objects.cross_section import csection
from pygmt_objects.surface_plot import csurface

## Create csection object and define the projection and colorpallete (from matplotlib.colors) to be used
csc = csection( proj="X5c/10c", cpallete="coolwarm", cmap="cmap.cpt" )

## Cross sections zonal jet
csc.hcolor_bar( b1="-0.3", b2="0.3", unit="m/s", outfile="85-bar-vphi.pdf" )
csc.cross_section( inf="85-mode1-vphi.dat",  outf="85-mode1-vp.pdf",  cB=0.3, cT=1.0, xnt="xf0.5", ynt="ya30", tgt="tgt.dat" )
csc.cross_section( inf="85-mode2a-vphi.dat", outf="85-mode2a-vp.pdf", cB=0.3, cT=1.0, xnt="xf0.5", ynt="ya30", tgt="tgt.dat" )
csc.cross_section( inf="85-mode2b-vphi.dat", outf="85-mode2b-vp.pdf", cB=0.3, cT=0.9, xnt="xa0.5f0.5", ynt="ya30", tgt="tgt.dat" )

## Cross section meridional circulation
csc.hcolor_bar( b1="-3.0", b2="3.0", unit="cm/s", outfile="85-bar-vtht.pdf" )
csc.cross_section( inf="85-mode1-vtht.dat",  outf="85-mode1-vt.pdf",  cB=0.03, cT=0.6, xnt="xf0.5", ynt="yf30" )
csc.cross_section( inf="85-mode2a-vtht.dat", outf="85-mode2a-vt.pdf", cB=0.03, cT=0.6, xnt="xf0.5", ynt="yf30" )
csc.cross_section( inf="85-mode2b-vtht.dat", outf="85-mode2b-vt.pdf", cB=0.03, cT=0.9, xnt="xa0.5f0.5", ynt="yf30" )

## Cross section radial velocity
csc.hcolor_bar( b1="-1.0", b2="1.0", unit="cm/s", outfile="85-bar-vrad.pdf" )
csc.cross_section( inf="85-mode1-vrad.dat",  outf="85-mode1-vr.pdf",  cB=0.01, cT=0.7, xnt="xf0.5", ynt="yf30" )
csc.cross_section( inf="85-mode2a-vrad.dat", outf="85-mode2a-vr.pdf", cB=0.01, cT=0.6, xnt="xf0.5", ynt="yf30" )
csc.cross_section( inf="85-mode2b-vrad.dat", outf="85-mode2b-vr.pdf", cB=0.01, cT=1.0, xnt="xa0.5f0.5", ynt="yf30" )

## Create csurface object and define the colorpallete (from matplotlib.colors) to be used
csf = csurface( proj="W180/12", cpallete="coolwarm", cmap="cmap.cpt" )

## Surface plots heat flux
csf.vcolor_bar( b1="0.70", b2="1.30", unit="q/@!\257q", outfile="85-bar-flux.pdf" )
csf.surface_plot( inf="85-mode1-flux.dat",  outf="85-mode1-fx.pdf", cB=0.30, cT=1.0, tgtn="tgt-n.dat", tgts="tgt-s.dat")
csf.surface_plot( inf="85-mode2a-flux.dat", outf="85-mode2a-fx.pdf", cB=0.30, cT=0.9, tgtn="tgt-n.dat", tgts="tgt-s.dat")
csf.surface_plot( inf="85-mode2b-flux.dat", outf="85-mode2b-fx.pdf", cB=0.30, cT=1.0, tgtn="tgt-n.dat", tgts="tgt-s.dat")

subprocess.run("rm -f cmap.cpt", shell=True)
