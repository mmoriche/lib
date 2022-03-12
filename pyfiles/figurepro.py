from functools import singledispatch
import os
from matplotlib.pyplot import *
from matplotlib.transforms import Bbox                                                                         


class FigurePro(Figure):
   ax=None
   ax2=[]
   desc=""
   label=""
   ww=6.0
   hh=6.0/1.618
   rect=None
   markedLine={}
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
                ww=6.0,hh=6.0/1.333,
                desc="",
                label=""):
      super().__init__(figsize, dpi, facecolor, edgecolor, linewidth,
                frameon, subplotpars, tight_layout, constrained_layout)

      self.rect=rect
      self.ww=ww
      self.hh=hh
      self.set_size_inches(ww,hh)
      #setattr(self,'ax',self.add_axes(rect, label="main"))
      self.ax=self.add_axes(rect, label="main")
      self.ax.patch.set_alpha(0.0)
      self.desc = desc
      self.label =label 
      self.ax2=[]
      self.markedLine={}

   def adddesc(self,atext,newline=True):
      self.desc="%s\n%s" % (self.desc, atext) 

   def mirrorax(self):
      n=len(self.ax2)
      self.ax2.append(self.add_axes(self.rect, label="%d" % (n,)))
      self.ax2[-1].patch.set_alpha(0.0)

   def pgfprint(self,odir='.',frmt='eps',tbm='tbmb',auxfrmt='png',auxleg=True, 
      suffix="",
      README=None, panel=None):

      if len(self.label)>0 and panel:
         figlabel="%s_%s" % (self.label, panel)
      elif len(self.label)>0:
         figlabel=self.label
      elif panel:
         figlabel=panel
      else:
         figlabel=""
      if suffix:
         if figlabel:
            figlabel=figlabel+"_"+suffix
         else:
            figlabel=suffix
     
      # save whole figure (for safety purposes)
      if len(figlabel)>0:
         ofnm_fig="%s/fig_%d-%s_WITHAXES.%s"  % (odir,self.number,figlabel,auxfrmt)
      else:
         ofnm_fig="%s/fig_%d_WITHAXES.%s"  % (odir,self.number,auxfrmt)
      if auxleg:
         l=self.ax.legend(bbox_to_anchor=(1.0,0.0,1,1))
         self.set_size_inches(4*self.ww,2*self.hh)
         bb=self.ax.get_position()
         self.ax.set_position(Bbox([[0.2,0.2],[0.5,0.8]]))
      self.savefig(ofnm_fig)
      if auxleg:
         l.remove()
         self.set_size_inches(self.ww,self.hh)

      # save clean axes
      if len(figlabel)>0:
         ofnm_fig="%s/fig_%d-%s.%s"  % (odir,self.number,figlabel,frmt)
      else:
         ofnm_fig="%s/fig_%d.%s"  % (odir,self.number,frmt)
      bb=self.ax.get_position()
      self.ax.set_position(Bbox([[0.0,0.0],[1.0,1.0]]))
      self.ax.axis("off")
      for i1 in range(len(self.ax2)):
         self.ax2[i1].set_position(Bbox([[0.0,0.0],[1.0,1.0]]))
         self.ax2[i1].axis("off")
         
      if frmt=="png":
         self.savefig(ofnm_fig,dpi=400)
      else:
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
         if figlabel:
            README.write(" Figure %d / %s \n" % (self.number,figlabel))
         else:
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
      if not README==None:
         README.write("\n\n")
  
   def setww(self,ww_):
      self.ww=ww_
      self.set_size_inches(self.ww,self.hh)
   def sethh(self,hh_):
      self.hh=hh_
      self.set_size_inches(self.ww,self.hh)

   def addNMarkers(self,label=None,marker='o',nmark=3,dshift=0,props={},xlim=False):
      if not 'marker' in props.keys(): props['marker']=marker
      if not 'ls' in props.keys(): props['ls']='none'
      alist=self.ax.get_children()
      for item in alist:
         if item.__class__.__name__ == 'Line2D':
            if label==item.get_label() or (label is None and not item.get_label().startswith('_')):
               newlabel='%s_marked' % (item.get_label(),)
               x=item.get_xdata(orig=False)
               y=item.get_ydata(orig=False)
               if not xlim:
                  n=x.shape; n=n[0]
                  ii=np.linspace(0,n-1,nmark+1,dtype='i')
                  ii=ii[0:-1]
                  ishift=int(dshift*n/nmark)
                  ii=(ii+ishift)%n
               else:
                  xl=self.ax.get_xlim()
                  jj=np.where( ( x>=xl[0] ) & ( x<=xl[1] ) )
                  if len(jj[0])==0:
                     ii=[]
                  else:
                     n=len(jj[0])
                     kk=np.linspace(0,n-1,nmark+1,dtype='i')
                     kk=kk[0:-1]
                     ishift=int(dshift*n/nmark)
                     kk=(kk+ishift)%n
                     ii=jj[0][kk]
               if len(ii)==0:
                  self.markedLine[newlabel]=self.ax.plot([],[],label=newlabel,**props)
               else:
                  self.markedLine[newlabel]=self.ax.plot(x[ii],y[ii],label=newlabel,**props)

   def removeMarkedLine_all(self):
      for item in self.markedLine.values():
         item.pop(0).remove()

   def removeMarkedLine_bylabel(self,label):
      newlabel='%s_marked' % (label,)
      item=self.markedLine[newlabel]
      item.pop(0).remove()
