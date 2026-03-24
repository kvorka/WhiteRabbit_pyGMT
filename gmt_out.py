import subprocess
from pygmt_objects.cross_section import csection
from pygmt_objects.surface_plot import csurface

# Create csection object and define the projection and colorpallete (from matplotlib.colors) to be used
csc = csection( proj="X5c/-10c", cmap="coolwarm", cpallete='coolwarm' )

#Color bars
#csc.vcolor_bar(b1="-0.06", b2="0.06", unit="", outfile="Vr-bar.pdf")
#csc.vcolor_bar(b1="-0.25", b2="0.25", unit="m/s", outfile="barr-vphi.pdf")
#csc.vcolor_bar(b1="-0.2", b2="0.2", unit="m/s", outfile="bar-vtht.pdf")
#csc.vcolor_bar(b1="-0.1", b2="0.1", unit="m/s", outfile="bar-vrad.pdf")

#Cross sections
csc.cross_section( inf="modXX-vphi.dat",  outf="modelXX-vp.pdf",  cB=30.0, cT=1.0, xnt="xf0.5", ynt="yf30")
csc.cross_section( inf="modXX-vtht.dat",  outf="modelXX-vt.pdf",  cB=10.0, cT=1.0, xnt="xa0.5", ynt="yf30")
#csc.cross_section( inf="test6-vrad.dat",  outf="test6-vr.pdf",  cB=0.02, cT=1.0, xnt="xa0.5", ynt="yf30")

#
#csc.cross_section( inf="modeIIa-vphi.dat",  outf="modeIIa-vp.pdf",  cB=2.5,  cT=1.0, xnt="xf0.5", ynt="yf30")
#csc.cross_section( inf="modeIIa-vtht.dat",  outf="modeIIa-vt.pdf",  cB=0.22, cT=1.0, xnt="xf0.5", ynt="yf30")
#csc.cross_section( inf="modeIIa-vrad.dat",  outf="modeIIa-vr.pdf",  cB=0.10, cT=1.0, xnt="xf0.5", ynt="yf30")
#
#csc.cross_section( inf="modeIIb-vphi.dat",  outf="modeIIb-vp.pdf",  cB=2.5,  cT=1.0, xnt="xf0.5", ynt="yf30")
#csc.cross_section( inf="modeIIb-vtht.dat",  outf="modeIIb-vt.pdf",  cB=0.22, cT=1.0, xnt="xf0.5", ynt="yf30")
#csc.cross_section( inf="modeIIb-vrad.dat",  outf="modeIIb-vr.pdf",  cB=0.10, cT=1.0, xnt="xf0.5", ynt="yf30")

#csc.cross_section( inf="modeIr-vphi.dat",  outf="modeIr-vp.pdf",  cB=0.25, cT=1.0, xnt="xa0.5", ynt="ya30")
#csc.cross_section( inf="modeIr-vtht.dat",  outf="modeIr-vt.pdf",  cB=0.22, cT=1.0, xnt="xa0.5", ynt="ya30")
#csc.cross_section( inf="modeIr-vrad.dat",  outf="modeIr-vr.pdf",  cB=0.10, cT=1.0, xnt="xa0.5", ynt="ya30")
#
#csc.cross_section( inf="modeIIar-vphi.dat",  outf="modeIIar-vp.pdf",  cB=0.25, cT=1.0, xnt="xa0.5", ynt="yf30")
#csc.cross_section( inf="modeIIar-vtht.dat",  outf="modeIIar-vt.pdf",  cB=0.22, cT=1.0, xnt="xa0.5", ynt="yf30")
#csc.cross_section( inf="modeIIar-vrad.dat",  outf="modeIIar-vr.pdf",  cB=0.10, cT=1.0, xnt="xa0.5", ynt="yf30")
#
#csc.cross_section( inf="modeIIbr-vphi.dat",  outf="modeIIbr-vp.pdf",  cB=0.25, cT=1.0, xnt="xa0.5", ynt="yf30")
#csc.cross_section( inf="modeIIbr-vtht.dat",  outf="modeIIbr-vt.pdf",  cB=0.22, cT=1.0, xnt="xa0.5", ynt="yf30")
#csc.cross_section( inf="modeIIbr-vrad.dat",  outf="modeIIbr-vr.pdf",  cB=0.10, cT=1.0, xnt="xa0.5", ynt="yf30")

#csc = csurface( proj="W12c" , cmap="coolwarm", cpallete="coolwarm" )
#csc.surface_plot( inf="flux-flux.dat", outf="flux-Europa.pdf", cB=0.20 )
#csc.vcolor_bar(b1="0.8", b2="1.2", unit="", outfile="bar-Europa.pdf")
#
subprocess.run("rm -f *.cpt", shell=True)
