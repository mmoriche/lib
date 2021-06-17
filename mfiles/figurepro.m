classdef figurepro

properties
handle;
label="";
ax;
axlist;
ww=6.0;
hh=6.0/1.618;
desc="";
papercolor='w';
end

methods
% Constructor
function self = figurepro(varargin)

   p=inputParser();
   addOptional(p,'label',self.label);
   parse(p,varargin{:});
   self.label=p.Results.label;

   self.handle=figure();
   set(self.handle,'Units','inches');
   self.axlist(1)=axes('Parent',self.handle);
   self.ax=self.axlist(1);
   hold(self.ax,'on');
   box(self.ax,'on');
return;
end

% close
function close(self)
   close(self.handle);
return;
end

% io
function pgfprint(self,varargin);
   default_odir='./';
   default_frmt='eps';
   default_tbm='tbmb';
   default_auxfrmt='png';
   default_auxleg=true;
   default_README='*';
   default_panel='*';
   
   valid_odir = @(x) exist(x,'dir');
   valid_frmt = @(x) any(find(strcmp(x,{'eps','png','jpg','jpeg'})));
   
   p=inputParser();
   addOptional(p,'odir',   default_odir,valid_odir );
   addOptional(p,'frmt',   default_frmt,valid_frmt );
   addOptional(p,'auxfrmt',default_auxfrmt,valid_frmt );
   addOptional(p,'tbm'    ,default_tbm);
   parse(p,varargin{:});
   odir=p.Results.odir;
   frmt=p.Results.frmt;
   tbm=p.Results.tbm;
   auxfrmt=p.Results.auxfrmt;
   
   figlabel=self.label;
   if length(figlabel)>1
      ofnm_fig=sprintf("%s/fig_%d-%s_WITHAXES.%s",odir,self.handle.Number,figlabel,auxfrmt);
   else
      ofnm_fig=sprintf("%s/fig_%d_WITHAXES.%s",odir,self.handle.Number,auxfrmt);
   end
   saveas(self.handle,ofnm_fig,auxfrmt);

  
   if length(self.axlist) > 1
      error("I can only handle one axes");
   end
   xl=get(self.ax,'XLim'); yl=get(self.ax,'YLim');


   set(self.handle, 'Units', 'inches');
   set(self.ax    , 'Units', 'inches');

   figsize0= get(self.handle,'Position');
   axsize0 = get(self.ax,'Position');

   set(self.handle, 'Position', [1.0 1.0 self.ww self.hh]);
   set(self.ax    , 'Position', [0.0 0.0 self.ww self.hh]);

   figsize = get(self.handle,'Position');
   figunits = get(self.handle,'Units');
   papercolor=self.papercolor;

   set(self.handle,'Position', figsize);
   set(self.handle,'PaperPosition',[0 0 figsize(3) figsize(4)]);
   set(self.handle,'PaperUnits',figunits);
   set(self.handle,'PaperSize',[figsize(3) figsize(4)]);
   set(self.handle,'PaperPosition',[0 0 figsize(3) figsize(4)]);

   set(self.handle, 'InvertHardCopy','off');
   ax2 = axes('Parent',self.handle,'Units', 'normalize', ...
    'Position', [0 0 1 1], 'Color', papercolor,'XColor',papercolor,'YColor',papercolor);
   set(ax2, 'Position', [0 0 1 1]);
   uistack(ax2, 'bottom')


   if length(figlabel)>1
      ofnm_fig=sprintf("%s/fig_%d-%s.%s",odir,self.handle.Number,figlabel,frmt);
   else
      ofnm_fig=sprintf("%s/fig_%d.%s",odir,self.handle.Number,frmt);
   end
   axis(self.ax,'off');
   saveargs = {};
   if strcmp(frmt,'eps') 
      print(self.handle,ofnm_fig,'-depsc',saveargs{:});
   else
      error("frmt");
   end
   delete(ax2)
   axis(self.ax,'on');

   set(self.handle,'Position',figsize0);
   set(self.ax,'Position',axsize0);

   if length(figlabel)>1
      ofnm_tex=sprintf("%s/fig_%d-%s.tex",odir,self.handle.Number,figlabel);
   else
      ofnm_tex=sprintf("%s/fig_%d.tex",odir,self.handle.Number);
   end
   fid=fopen(ofnm_tex,'w');
   fprintf(fid,'%% width=%f in,\n',self.ww);
   fprintf(fid,'%% height=%f in,\n',self.hh);
   fprintf(fid,'%% xlabel={%f}\n',get(get(self.ax,'XLabel'),'String'));
   fprintf(fid,'%% ylabel={%f}\n',get(get(self.ax,'YLabel'),'String'));
   fprintf(fid,'%%\\begin{axis}[scale only axis, enlargelimits=false, axis on top,width=%fin,height=%fin]\n',self.ww,self.hh);
   if length(figlabel)>1
      fprintf(fid,'\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\%s/fig_%d-%s.%s};',xl(1),xl(2),yl(1),yl(2),tbm,self.handle.Number,figlabel,frmt);
   else
      fprintf(fid,'\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\%s/fig_%d.%s};',xl(1),xl(2),yl(1),yl(2),tbm,self.handle.Number,frmt);
   end
   fclose(fid);
return;
end

function saveLine2D(self,varargin)
   default_odir='./';
   valid_odir = @(x) exist(x,'dir');
   p=inputParser();
   addOptional(p,'odir',   default_odir,valid_odir );
   parse(p,varargin{:});
   odir=p.Results.odir;

   figlabel=self.label;

   mychildren=findobj(self.ax,'Type','Line');
   nl=length(mychildren);

   if length(figlabel)>1
      odir_data=sprintf("%s/fig_%d-%s_data",odir,self.handle.Number,figlabel);
   else
      odir_data=sprintf("%s/fig_%d_data",odir,self.handle.Number);
   end
   if ~exist(odir_data,'dir'), system(sprintf('mkdir %s',odir_data));end
   for i1 = 1:nl
      l=mychildren(i1);
      tag=get(l,'Tag');
      if ~isempty(tag)
         ofnm=sprintf("%s/%s.dat",odir_data, strrep(tag,' ','_'));
         x=get(l,'XData');
         y=get(l,'YData');
         fid=fopen(ofnm,'w');
         nd=length(x(:));
         fprintf(fid,'%25s %25s\n','x','y');
         for i2 = 1:nd
            fprintf(fid,'%25.15E %25.15E\n',x(i2),y(i2));
         end
         fclose(fid);
      end
   end

return;
end


end

end


