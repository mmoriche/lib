classdef XYPlot < MatlabFigure;
% @author M.Moriche
% @date 18-10-2014 by M.Moriche \n
%       plotlegends() modified
% @date 25-11-2014 by M.Moriche \n
%       plotlegend() modified
%

properties
legendjoiner;
legendbeg;
scale;
end

methods
function self = XYPlot(handle,indx,cap,glb,tex,varargin)
  legendjoiner = ', ';
  legendbeg = '';
  scale = 0.4;
  papercolor = 'w';
  auxfiles=true;
  misc.assigndefaults(varargin{:});
  self@MatlabFigure(handle, indx, cap, glb,tex, ...
   'papercolor', papercolor,'auxfiles',auxfiles);
  self.legendjoiner = legendjoiner;
  self.legendbeg= legendbeg;
  self.scale = scale;
return
end

function filelist = save(self,objectspath, ansysnm, varargin)
   % files generated:
   % objectspath/ansysnm/ansysnm_<indx>.frmt
   % objectspath/ansysnm/ansysnm_<indx>_data/
   saveargs = {};
   frmt = 'pdf';
   misc.assigndefaults(varargin{:});

   display(sprintf('saving XYPlot  %d, %s, %s',self.indx,self.cap,self.glb))

   % save the figure object, caption and global caption
   %filelist_1 = save@MatlabFigure(self, fnm, frmt, 'saveargs', saveargs);
   filelist_1 = save@MatlabFigure(self,objectspath,ansysnm,frmt,...
                                 'saveargs',saveargs);

   % save legend if it has to
   cap0 = self.cap;
   glb0 = self.glb;
   filelist_2a = {};
   filelist_2b = {};
   if ~isempty(findstr('seriesinfo',self.cap))
      [seriesinfo, filelist_2a] = self.plotlegends(objectspath,  ansysnm, ...
       'legendjoiner', self.legendjoiner, 'legendbeg', self.legendbeg, ...
        'scale', self.scale);
      self.cap = strrep(self.cap,'seriesinfo',seriesinfo);
       
      display('')
      display('')
      display(' seriesinfo ---- obsolte method. About to disappear ----')
      display(' USE GENLEGEND AND SAVE CAPTIONS IN TEX FIELD OF FIGURE')
      display(' cap and glb only for info in scripts')
      display(' tex for captions')
      display('')
      display('')
   end

   if ~isempty(findstr('seriesinfo',self.glb))
      [seriesinfo, filelist_2b] = self.plotlegends(objectspath,  ansysnm, ...
       'legendjoiner', self.legendjoiner, 'legendbeg', self.legendbeg, ...
        'scale', self.scale);
      self.glb = strrep(self.glb,'seriesinfo',seriesinfo);
      display('')
      display('')
      display(' seriesinfo ---- obsolte method. About to disappear ----')
      display(' USE GENLEGEND AND SAVE CAPTIONS IN TEX FIELD OF FIGURE')
      display(' cap and glb only for info in scripts')
      display(' tex for captions')
      display('')
      display('')
   end

   filelist_2 = cat(1, filelist_2a, filelist_2b);
   filelist_3 = save@ResultsItem(self,objectspath,ansysnm);

   self.cap = cap0;
   self.glb = glb0;

   filelist = cat(1, filelist_1, filelist_2, filelist_3);

return
end

function filelist = saveraw(self,objectspath, ansysnm, varargin)
   % files generated:
   % objectspath/ansysnm/ansysnm_<indx>.frmt
   % objectspath/ansysnm/ansysnm_<indx>_data/
   saveargs = {};
   frmt = 'pdf';
   misc.assigndefaults(varargin{:});

   display(sprintf('saving XYPlot  %d, %s, %s',self.indx,self.cap,self.glb))

   fnm = self.getfullfilename(objectspath, ansysnm);
   datadir = objectspath;
   system(sprintf('mkdir -p %s',datadir));

   % save the figure object, caption and global caption
   filelist = saveraw@MatlabFigure(self, fnm, frmt, 'saveargs', saveargs);

return
end

function [mystr, filelist] = plotlegends(self,objectspath,ansysnm, varargin)
   % @author M.Moriche
   % @date 18-10-2014 by M.Moriche \n
   %       Reverse the order of the series.
   % @date 25-11-2014 by M.Moriche \n
   %       Bug in sedata.DisplayName
   %

   frmt = 'pdf';
   legendjoiner = ', ';
   legendbeg = '';
   legendend = '';
   scale = 0.4;
   misc.assigndefaults(varargin{:});
   x0=0;
   xf=4;
   y0=0;
   yf=0;
   
   filelist = {};
   
   mysize = [0.8 0.2];
   mysize2= [0.3 0.2];
   vv = [0 0 mysize];
   
   conf.Units = 'inches';
   conf.Position = [0 0 mysize];
   conf.PaperPosition = [0 0 mysize];
   conf.PaperSize     = mysize;
   conf.Visible = 'off';

   conf2.Units = 'inches';
   conf2.Position = [0 0 mysize2];
   conf2.PaperPosition = [0 0 mysize2];
   conf2.PaperSize     = mysize2;
   conf2.Visible = 'off';
   
   axconf.Units='normalized';
   %axconf.Position=[0.1 0.1 0.8 0.8];
   axconf.Position=[0 0 1 1];
   axconf.DataAspectRatio = [1 1 1];
   axconf.Visible = 'off';

   fig = self.handle;
   serieslist = get(fig,'Children');
   strnglist = {};
   %for iiii = 1:length(serieslist) 
   fnm = self.getfullfilename2(objectspath, ansysnm);
   fnm2 = ['\temppath_', sprintf('%d',self.indx) '_data/' ...
                         sprintf('%s_%d',ansysnm,self.indx) ];

   iser2 = 0;
   for iiii = length(serieslist):-1:1
      seriess = serieslist(iiii);
      series = get(seriess,'Children'); 
                 

      for iser = length(series):-1:1

         se = get(series(iser));
         sedata = struct;

         fldlist = {'LineStyle','Color','DisplayName','Marker','MarkerFaceColor','LineWidth',...
                                                               'MarkerEdgeColor','MarkerSize'};
       
         for jjj = 1:length(fldlist)
            fldnm = fldlist{jjj};
            try  
               sedata.(fldnm) = se.(fldnm);
            catch
               fldnm;
            end
         end
         try
            sedata.LineWidth   = sedata.LineWidth*scale;
            sedata.MarkerSize  = sedata.MarkerSize*scale;
         catch
            sedata.LineWidth   = 1;
         end
         
         if ~isempty(fields(sedata))
            if ~isempty(find(strcmp(fields(sedata),'DisplayName')))
               if ~isempty(sedata.DisplayName)
                  iser2 = iser2 + 1;
                  if strcmp(sedata.LineStyle, 'none')
                     figaux = figure(conf2);
                     plot(x0,y0, sedata);
                  else
                     figaux = figure(conf);
                     plot([x0 xf], [y0 yf], sedata);
                  end
                  set(gca,axconf);
                  legfile = sprintf('%s.%d.%s',fnm, iser2, frmt);
                  saveas(figaux,legfile);
                  delete(figaux)
                  % generate tex string
                  legfile2 = sprintf('{%s.%d}.%s',fnm2, iser2, frmt);
                  strnglist = [strnglist sprintf('(\\includegraphics{%s}) %s' ,...
                               legfile2,sedata.DisplayName)];
                  filelist = cat(1, filelist, legfile);
               end
            end
         end
         clear sedata
      end
 
   end

   mystr = [legendbeg sprintf('\n')...
            misc.strjoin(strnglist,[legendjoiner '\n'])...
            legendend sprintf('\n') ];

return
end


end
end
