classdef MatlabFigure  < ResultsItem
%
%
% cap: specific info of figure, only for info, should be short
% glb: common info with more figures, only for info, should be short
% tex: field to use as caption in figure, can be long, not appearss in summ
%
%
properties
tex
papercolor
end

methods

function self = MatlabFigure(handle, indx, cap, glb, tex, varargin)

   papercolor  = 'w';
   auxfiles=true;
   summ=true;
   misc.assigndefaults(varargin{:});
   self@ResultsItem(handle, indx, cap, glb,'auxfiles',auxfiles,'summ',summ)
   self.tex = tex;
   self.papercolor = papercolor;

return
end

function filelist = save(self,objectspath,ansysnm,frmt,varargin)

   saveargs = {};
   trim = false;
   skipexisting = false;
   misc.assigndefaults(varargin{:});

   fnm = self.getfullfilename(objectspath, ansysnm);
   shortfnm = self.getpathname(ansysnm);

   fig = self.handle;
   figsize = get(fig,'Position');
   figunits = get(fig,'Units');

   papercolor = self.papercolor;

   set(fig,'PaperUnits',figunits);
   set(fig,'PaperSize',[figsize(3) figsize(4)]);
   set(fig,'PaperPosition',[0 0 figsize(3) figsize(4)]);

   ffig = [fnm '.' frmt];
   filelist = {ffig};
   if exist(ffig,'file') && skipexisting 
      disp('skipping existing file')
   else
      if strcmp(frmt, 'pdf')
         set(fig, 'InvertHardCopy','off')
         print(fig,ffig,'-dpdf',saveargs{:});
      elseif strcmp(frmt, 'png')
         print(fig,ffig,'-dpng',saveargs{:});
         if trim
            systep(sprintf('convert -trim %s %s',ffig,ffig))
         end

      elseif strcmp(frmt, 'pgfpng')

         fpgf = [fnm '_pgfpng.tex'];
         ffig = [fnm '_pgfpng.png'];
         sfig = [shortfnm '_pgfpng.png'];

         pp=get(fig,'Position');
         pp=pp*0.5;
         %ax=get(fig,'Children');
         ax=findobj(fig,'Type','Axes');
         xl=get(ax,'XLim'); yl=get(ax,'YLim');

         fid=fopen(fpgf,'w');
         fprintf(fid,'\%\\begin{axis}[scale only axis, enlargelimits=false, axis on top,width=%fin,height=%fin]\n',pp(3),pp(4));
         fprintf(fid,'\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\tbm/%s};',xl(1),xl(2),yl(1),yl(2),sfig);
         fclose(fid);
         print(fig,ffig,'-dpng',saveargs{:});
         if trim
            systep(sprintf('convert -trim %s %s',ffig,ffig))
         end
      elseif strcmp(frmt, 'eps')
         ax2 = axes('Parent',fig,'Units', 'normalize', ...
          'Position', [0 0 1 1], 'Color', papercolor,'XColor',papercolor,'YColor',papercolor);
         uistack(ax2, 'bottom')
         set(fig, 'InvertHardCopy','off')
         set(ax2, 'Position', [0 0 1 1]);
         set(fig, 'Position', figsize);
         set(fig,'PaperPosition',[0 0 figsize(3) figsize(4)]);
         %print(fig,ffig,'-dpsc2',saveargs{:});
         print(fig,ffig,'-depsc',saveargs{:});
         delete(ax2)
      elseif strcmp(frmt, 'pgfeps')

         fpgf = [fnm '_pgfeps.tex'];
         ffig = [fnm '_pgfeps.eps'];
         sfig = [shortfnm '_pgfeps.eps'];

         pp=get(fig,'Position');
         pp=pp*0.5;
         %ax=get(fig,'Children');
         ax=findobj(fig,'Type','Axes');
         xl=get(ax,'XLim'); yl=get(ax,'YLim');

         fid=fopen(fpgf,'w');
         fprintf(fid,'%\\begin{axis}[scale only axis, enlargelimits=false, axis on top,width=%fin,height=%fin]\n',pp(3),pp(4));
         fprintf(fid,'\\addplot[] graphics [xmin=%E,xmax=%E,ymin=%E,ymax=%E] {\\tbm/%s};',xl(1),xl(2),yl(1),yl(2),sfig);
         fclose(fid);

         ax2 = axes('Parent',fig,'Units', 'normalize', ...
          'Position', [0 0 1 1], 'Color', papercolor,'XColor',papercolor,'YColor',papercolor);
         uistack(ax2, 'bottom')
         set(fig, 'InvertHardCopy','off')
         set(ax2, 'Position', [0 0 1 1]);
         set(fig, 'Position', figsize);
         set(fig,'PaperPosition',[0 0 figsize(3) figsize(4)]);

         print(fig,ffig,'-depsc',saveargs{:});
         delete(ax2)

      else

         saveas(fig,ffig,frmt,saveargs{:});

      end
   end

   % achtung
   if self.auxfiles
      datadir = self.getdatadir(objectspath, ansysnm);
      fnm = self.getfilename(ansysnm);
      system(sprintf('mkdir -p %s', datadir));

      ftex = fullfile(datadir, [fnm '.tex']);
      fid = fopen(ftex,'w');
      fwrite(fid, self.tex);
      fclose(fid);

      filelist = cat(1,filelist, ftex);
   end

return
end

function filelist = saveraw(self,fnm,frmt,varargin)

   saveargs = {};
   misc.assigndefaults(varargin{:});
   fig = self.handle;
   figsize = get(fig,'Position');
   figunits = get(fig,'Units');

   set(fig,'PaperUnits',figunits);
   set(fig,'PaperSize',[figsize(3) figsize(4)]);
   set(fig,'PaperPosition',[0 0 figsize(3) figsize(4)]);

   ffig = [fnm '.' frmt];
   filelist = {ffig};
   saveas(fig,fnm,saveargs{:});


return
end

end

end
