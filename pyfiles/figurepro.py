import os
from matplotlib.pyplot import *
from matplotlib.transforms import Bbox                                                                         


class FigurePro(Figure):
   ax=None
   ax2=[]
   desc=""
   label=""
   rect=None
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
                ww=6.0,hh=6.0/1.618,
                desc="",
                label=""):
      super().__init__(figsize, dpi, facecolor, edgecolor, linewidth,
                frameon, subplotpars, tight_layout, constrained_layout)

      self.rect=rect
      self.set_size_inches(ww,hh)
      #setattr(self,'ax',self.add_axes(rect, label="main"))
      self.ax=self.add_axes(rect, label="main")
      self.ax.patch.set_alpha(0.0)
      self.desc = desc
      self.label =label 
      self.ax2=[]

   def adddesc(self,atext,newline=True):
      self.desc="%s\n%s" % (self.desc, atext) 

   def mirrorax(self):
      n=len(self.ax2)
      self.ax2.append(self.add_axes(self.rect, label="%d" % (n,)))
      self.ax2[-1].patch.set_alpha(0.0)

   def pgfprint(self,odir='.',frmt='eps',tbm='tbmb',auxfrmt='png',auxleg=True, 
      README=None, panel=None):

      if len(self.label)>0 and panel:
         figlabel="%s_%s" % (self.label, panel)
      elif len(self.label)>0:
         figlabel=self.label
      elif panel:
         figlabel=panel
      else:
         figlabel=""
      # save whole figure (for safety purposes)
      if len(figlabel)>0:
         ofnm_fig="%s/fig_%d-%s_WITHAXES.%s"  % (odir,self.number,figlabel,auxfrmt)
      else:
         ofnm_fig="%s/fig_%d_WITHAXES.%s"  % (odir,self.number,auxfrmt)
      if auxleg: l=self.ax.legend()
      self.savefig(ofnm_fig)
      if auxleg: l.remove()

      # save clean axes
      if len(figlabel)>0:
         print("hola")
         ofnm_fig="%s/fig_%d-%s.%s"  % (odir,self.number,figlabel,frmt)
      else:
         print("adios")
         ofnm_fig="%s/fig_%d.%s"  % (odir,self.number,frmt)
      bb=self.ax.get_position()
      self.ax.set_position(Bbox([[0.0,0.0],[1.0,1.0]]))
      self.ax.axis("off")
      for i1 in range(len(self.ax2)):
         self.ax2[i1].set_position(Bbox([[0.0,0.0],[1.0,1.0]]))
         self.ax2[i1].axis("off")
         
      self.savefig(ofnm_fig)
      self.ax.set_position(bb)
      self.ax.axis("on")
      for i1 in range(len(self.ax2)):
         self.ax2[i1].set_position(bb)
         self.ax2[i1].axis("on")
      
      # save .tex file
      if len(figlabel)>0:
         ofnm_tex="%s/fig_%d-%s.tex"  % (odir,self.number,figlabel)
      else:
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
      if len(figlabel)>0:
         f.write("\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\%s/fig_%d-%s.%s};" % (xlim[0],xlim[1],ylim[0],ylim[1],tbm,self.number,figlabel,frmt))
      else:
         f.write("\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\%s/fig_%d.%s};" % (xlim[0],xlim[1],ylim[0],ylim[1],tbm,self.number,frmt))
      f.close()



      for i1 in range(len(self.ax2)):
         print(i1)
         print(i1)
         print(i1)
         print(i1)
         print(i1)
         # save .tex file
         if len(figlabel)>0:
            ofnm_tex="%s/fig_%d-%s-extra_%d.tex"  % (odir,self.number,figlabel,i1)
         else:
            ofnm_tex="%s/fig_%d-extra_%d.tex"  % (odir,self.number,i1)
         xlim=self.ax2[i1].get_xlim()
         ylim=self.ax2[i1].get_ylim()
         f=open(ofnm_tex,'w')
         # write header as comments
         bb=self.bbox_inches
         f.write("%% width=%f in, \n" % bb.width  )
         f.write("%% height=%f in, \n" % bb.height  )
         f.write("%% xlabel={%s}, \n" % self.ax2[i1].get_xlabel()  )
         f.write("%% ylabel={%s}, \n" % self.ax2[i1].get_ylabel()  )
         f.write("%%\n")
         f.write("%% Line2D objects: \n")
         alist=self.ax2[i1].get_children()
         for item in alist:
            if item.__class__.__name__ == 'Line2D':
               label=item.get_label()
               if len(label)>0 and not label.startswith('_'): 
                  f.write("%% %s : %s\n" % (item.get_label(), item.get_color()))
         # write line that can be directly included with \input{file}
         if len(figlabel)>0:
            f.write("\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\%s/fig_%d-%s.%s};" % (xlim[0],xlim[1],ylim[0],ylim[1],tbm,self.number,figlabel,frmt))
         else:
            f.write("\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\%s/fig_%d.%s};" % (xlim[0],xlim[1],ylim[0],ylim[1],tbm,self.number,frmt))
         f.close()




      if not README==None:
         README.write(" Figure %d \n" % self.number)
         README.write("\n")
         README.write(" %s\n" % self.desc)
         README.write("\n")
         README.write(" Line2D items: \n")
         for item in alist:
            if item.__class__.__name__ == 'Line2D':
               label=item.get_label()
               if len(label)>0 and not label.startswith('_'): 
                  README.write("    - %s : %s\n" % (item.get_label(), item.get_color()))
         README.write("\n")
         README.write("\n")
   

   def saveLine2D(self,odir='.',README=None, panel=None):
      alist=self.ax.get_children()

      if len(self.label)>0:
         odir_data="%s/fig_%d-%s_data"  % (odir,self.number,self.label)
      else:
         odir_data="%s/fig_%d_data"  % (odir,self.number)
      if not os.path.isdir(odir_data): os.system('mkdir %s' % odir_data)

      if panel: odir_data="%s/%s"  % (odir_data,panel)
      if not os.path.isdir(odir_data): os.system('mkdir %s' % odir_data)

      if not README==None:
         README.write(" ASCII data of Line2D objects from Figure %d:\n" % (self.number,))

      for item in alist:
         if item.__class__.__name__ == 'Line2D':
            label=item.get_label()
            if len(label)>0 and not label.startswith('_'): 
               header="%s - %s" % (item.get_label(), item.get_color())
               ofnm="%s/%s.dat"  % (odir_data, item.get_label().replace(' ','_'))
               if not README==None:
                  README.write(" - %s \n" % (header,))
               f=open(ofnm,'w')
               f.write("%25s %25s\n" % ("x","y")) 
               x=item.get_xdata(orig=False)
               y=item.get_ydata(orig=False)
               n=x.shape; n=n[0]
               for j in range(n):
                   f.write("%25.15E %25.15E\n" % (x[j], y[j])) 
               f.close()
  
