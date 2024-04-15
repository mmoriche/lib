import os,sys
import matplotlib.pyplot as plt
from matplotlib.transforms import Bbox                                                                         
import numpy as np


cmapName = sys.argv[1]
oFnm = sys.argv[2]

fig = plt.figure()
a = np.linspace(0,1,256)
plt.imshow([a,a], cmap=cmapName)

fig.set_size_inches(8,2)
ax=fig.gca()
ax.set_position(Bbox([[0.0,0.0],[1.0,1.0]]))
ax.axis("off")
ax.axis("tight")
fig.savefig(oFnm)

