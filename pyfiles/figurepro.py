from matplotlib.pyplot import *
from matplotlib.transforms import Bbox                                                                         


class FigurePro(Figure):
   ax=None
   def __init__(self,
                figsize=None,
                dpi=None,
                facecolor=None,
                edgecolor=None,
                linewidth=0.0,
                frameon=None,
                subplotpars=None,  # rc figure.subplot.*
                tight_layout=None,  # rc figure.autolayout
                constrained_layout=None,  # rc figure.constrained_layout.use
                rect=(0.2,0.2,0.7,0.7), ## NEW ARGUMENTS
                ww=6.0,hh=6.0/1.618):
      super().__init__(figsize, dpi, facecolor, edgecolor, linewidth,
                frameon, subplotpars, tight_layout, constrained_layout)

      self.set_size_inches(ww,hh)
      #setattr(self,'ax',self.add_axes(rect, label="main"))
      self.ax=self.add_axes(rect, label="main")
      self.ax.patch.set_alpha(0.0)

   def pgfprint(self,odir='.',frmt='eps',tbm='tbmb'):

      # save whole figure (for safety purposes)
      ofnm_fig="%s/fig_%d_WITHAXES.%s"  % (odir,self.number,frmt)
      self.savefig(ofnm_fig)

      # save clean axes
      ofnm_fig="%s/fig_%d.%s"  % (odir,self.number,frmt)
      bb=self.ax.get_position()
      self.ax.set_position(Bbox([[0.0,0.0],[1.0,1.0]]))
      self.ax.axis("off")
      self.savefig(ofnm_fig)
      self.ax.set_position(bb)
      self.ax.axis("on")
      
      # save .tex file
      ofnm_tex="%s/fig_%d.tex"  % (odir,self.number)
      xlim=self.ax.get_xlim()
      ylim=self.ax.get_ylim()
      f=open(ofnm_tex,'w')
      # write header as comments
      bb=self.bbox_inches
      f.write("%% width=%f in, \n" % bb.width  )
      f.write("%% height=%f in, \n" % bb.height  )
      f.write("%% xlabel={%s}, \n" % self.ax.get_xlabel()  )
      f.write("%% ylabel={%s}, \n" % self.ax.get_ylabel()  )
      f.write("%%\n")
      f.write("%% Line2D objects: \n")
      alist=self.ax.get_children()
      for item in alist:
         if item.__class__.__name__ == 'Line2D':
            label=item.get_label()
            if len(label)>0 and not label.startswith('_'): 
               f.write("%% %s : %s\n" % (item.get_label(), item.get_color()))
      # write line that can be directly included with \input{file}
      f.write("\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\%s/fig_%d.%s};" % (xlim[0],xlim[1],ylim[0],ylim[1],tbm,self.number,frmt))
      f.close()




