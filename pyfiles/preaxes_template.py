import os,sys
from os.path import join as fullfile
import numpy as np
from matplotlib.pyplot import *

GITHUB=os.environ['GITHUB_PATH']
sys.path.append(fullfile(GITHUB,'WORK/lib/pyfiles'))
from figurepro import FigurePro


odir=sys.argv[-1]

fig=figure(FigureClass=FigurePro,ww=3.,hh=3.*0.75,
           desc="zp vs time, time gravity scale, z as in code",
           label='xcode')
colors = cm.get_cmap('Dark2_r').colors
markers=['^','o','v','X','s']

auxmarkers={'ls':'none','marker':markers[i1],'markerfacecolor':'none','markeredgecolor':'k'}
fig.addNMarkers(dshift=0.5*i1/nc,label=f"{cdir}",props=auxmarkers,xlim=True) 


README=open("%s.README" % (odir,),"w")
fig.saveLine2D(odir,README=README)
fig.pgfprint(odir,frmt='eps')
fig.ax.set_xlim([0,1])
fig.pgfprint(odir,frmt='eps',README=README,suffix='zoom')
README.close()
