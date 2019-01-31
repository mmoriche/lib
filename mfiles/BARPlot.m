classdef BARPlot < MatlabFigure;
% @author M.Moriche
% @date 18-10-2014 by M.Moriche \n
%       plotlegends() modified
%

properties
legendjoiner;
legendbeg;
scale;
end

methods
function self = BARPlot(handle, indx, cap, glb)
  self@MatlabFigure(handle, indx, cap, glb)
return
end

function save(self,objectspath, ansysnm, varargin)

   frmt = 'pdf';
   notespath = '*';
   misc.assigndefaults(varargin{:});

   % if notespath is given, calculate the relative path for the legends
   if strcmp(notespath, '*')
      relativepath = objectspath;
   else
      [relativepath isrel] = misc.relatepaths(objectspath, notespath); 
   end
   display(sprintf('saving BARPlot  %d, %s, %s',self.indx,self.cap,self.glb))

   fnm = self.getfullfilename(objectspath, ansysnm);
   datadir = self.getdatadir(objectspath, ansysnm);
   system(sprintf('mkdir -p %s',datadir));

   % save the figure object, caption and global caption
   save@MatlabFigure(self, fnm, frmt);

   % save legend if it has to
   cap0 = self.cap;
   glb0 = self.glb;
   if ~isempty(findstr('seriesinfo',self.cap))
      %seriesinfo = self.plotlegends(objectspath, relativepath, ansysnm);
      seriesinfo = self.plotlegends(objectspath,  ansysnm, 'legendjoiner', self.legendjoiner, 'legendbeg', self.legendbeg, 'scale', self.scale);
      %seriesinfo = self.texlegend(objectspath,ansysnm,frmt);
      self.cap = strrep(self.cap,'seriesinfo',seriesinfo);
   end

   if ~isempty(findstr('seriesinfo',self.glb))

      %seriesinfo = self.plotlegends(objectspath, relativepath, ansysnm);
      seriesinfo = self.plotlegends(objectspath,  ansysnm, 'legendjoiner', self.legendjoiner, 'legendbeg', self.legendbeg, 'scale', self.scale);
      self.glb = strrep(self.glb,'seriesinfo',seriesinfo);
   end

   save@ResultsItem(self,objectspath,ansysnm);
   self.cap = cap0;
   self.glb = glb0;
return
end

function mystr = plotlegends(self,objectspath,ansysnm, varargin)
   % @author M.Moriche
   % @date 18-10-2014 by M.Moriche \n
   %       Reverse the order of the series.
   %

   frmt = 'pdf';
   legendjoiner = ', ';
   legendbeg = '';
   legendend = '';
   scale = 1;
   misc.assigndefaults(varargin{:});
   x0=0;
   xf=1;
   y0=0;
   yf=0.5;
   xx = [x0 xf xf x0];
   yy = [y0 y0 yf yf];
   
   
   dx = xf - x0;
   dy = yf - y0;
   mysize = 0.2*[dx dy];
   vv = [0 0 mysize];
   
   conf.Units = 'inches';
   conf.Position = [0 0 mysize];
   conf.PaperPosition = [0 0 mysize];
   conf.PaperSize     = mysize;
   conf.Visible = 'off';
   
   axconf.Units='normalized';
   %axconf.Position=[0.1 0.1 0.8 0.8];
   axconf.Position=[0 0 1 1];
   axconf.Visible = 'off';
   axconf.DataAspectRatio = [1 1 1];

   fig = self.handle;
   serieslist = get(fig,'Children');
   strnglist = {};
   %for iiii = 1:length(serieslist) 
   for iiii = length(serieslist):-1:1
      seriess = serieslist(iiii);
      series = get(seriess,'Children'); 

      fnm = self.getfullfilename2(objectspath, ansysnm);
      fnm2 = ['\temppath_', sprintf('%d',self.indx) '_data/' ...
                            sprintf('%s_%d',ansysnm,self.indx) ];

      iser2 = 0;
      for iser = length(series):-1:1

         se = get(series(iser));
         sedata = struct;

         fldlist = {'FaceColor','EdgeColor','DisplayName'};
       
         for jjj = 1:length(fldlist)
            fldnm = fldlist{jjj};
            try  
               sedata.(fldnm) = se.(fldnm);
            catch
               fldnm;
            end
         end
         
         if ~isempty(fields(sedata))
            if ~isempty(find(strcmp(fields(sedata),'DisplayName')))
               if ~isempty(sedata.DisplayName)
                  iser2 = iser2 + 1;
                  figaux = figure(conf);
 
                  fill(xx,yy, 'k', sedata);
                  
                  set(gca,axconf);
                  legfile = sprintf('%s.%d.%s',fnm, iser, frmt);
                  saveas(figaux,legfile);
                  delete(figaux)
                  % generate tex string
                  legfile2 = sprintf('{%s.%d}.%s',fnm2, iser, frmt);
                  strnglist = [strnglist sprintf('(\\includegraphics{%s}) %s' ,...
                               legfile2,sedata.DisplayName)];

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
