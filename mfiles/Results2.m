classdef Results2  < dynamicprops
% 
% @author M.Moriche
% @brief Class to handle post-processing of results
% @date 18-05-2014 by M.Moriche \n
%       Created
% @date 03-12-2014 by M.Moriche \n
%       indx as output for the addItem
%
% @details
% 
% - EXAMPLES:
%
% @code
% rs = Results2('analsysis','/dir/to/figsandtabs');
% rs.addXYPlot(fig, 'indx', 1, 'cap', 'hola', 'glb','adios');
% rs.save();
% @endcode
properties
   ansysnm
   objectspath
   notespath
   items        % list with post-processed items
end

methods
function self = Results2(ansysnm, objectspath, varargin)
   %
   %
   %  MANDATORY ARGUMENTS:
   %  - ansysnm: reference name of the analysis
   %  - objectspath: path where figures and tables are to be saved
   %
   %  OPTIONAL ARGUMENTS:
   %  - notespath: path where the notes file is to be saved.
   %               If notes path is given, the path written in the
   %               .cap and .glb files will be the relative path to
   %               go from notespath to objectspath
   %
   %
   notespath = '*';
   misc.assigndefaults(varargin{:});
   self.ansysnm     = ansysnm;
   self.objectspath = objectspath;
   self.notespath   = notespath;
  
   self.items = {};

return
end

function indx = addXYPlot(self, handle, varargin)

   indx = 1;
   cap = ' '; 
   glb = ' ';
   legendjoiner = ', ';
   legendbeg = '';
   scale = 1;
   misc.assigndefaults(varargin{:});

   indx = self.finduniqueindx('ResultsItem',indx);
 
   item = XYPlot(handle,indx, cap, glb, 'legendjoiner', legendjoiner, 'legendbeg', legendbeg, 'scale', scale); 
   
   self.items = [self.items {item}];

return
end

function indx = addBARPlot(self, handle, varargin)

   indx = 1;
   cap = ' '; 
   glb = ' ';
   misc.assigndefaults(varargin{:});

   indx = self.finduniqueindx('ResultsItem',indx);
 
   item = BARPlot(handle,indx, cap, glb); 
   
   self.items = [self.items {item}];

return
end

function indx = addTable(self, table, varargin)

   indx = 1;
   cap = ' '; 
   glb = ' ';
   halign = '*';
   misc.assigndefaults(varargin{:});

   indx = self.finduniqueindx('ResultsItem',indx);
 
   item = Table(table,indx, cap, glb,'halign',halign); 
   
   self.items = [self.items {item}];

return
end
function indxlist = getindxlist(self, classname)

   indxlist = [];
   for i = 1:length(self.items)
      item = self.items(i);
      item = item{1};
      if isa(item, classname)
         indxlist = [indxlist item.indx];
      end
   end

return
end

function item = getitembyindx(self, indx)
   indxlist = self.getindxlist('ResultsItem');
   for i = 1:length(indxlist)
       indx1 = indxlist(i);
       if indx1 == indx
          item = self.items(i);
          break
       end
   end
   
return
end

function summ(self, varargin);
   % \date 09-10-2014 by M.Moriche \n
   %       sort indxlist
   
   indxlist = self.getindxlist('ResultsItem');
   indxlist = sort(indxlist);

   objectspath = self.objectspath;
   notespath   = self.notespath;
   ansysnm = self.ansysnm;

   system(sprintf('mkdir -p %s' , objectspath ));
   system(sprintf('mkdir -p %s' , fullfile(objectspath, ansysnm )));

   tab = cell(1,4);
   tab(1,:) = {'Object','index', 'caption','Global caption'};
   editcap = @(cap) strrep(cap,'\newline',' ');
   for i = 1:length(indxlist)
      indx = indxlist(i);
      item = self.getitembyindx(indx);
      item = item{1};
      tab(i+1,:) = {class(item),num2str(item.indx),editcap(item.cap),...
                                                   editcap(item.glb)};
   end

   mystr = mytab.tab2ascii2(tab,[10,5,27,27],'cap',self.ansysnm);
   display(mystr)
 
   fnm = self.getREADMEfnm();
   fid = fopen(fnm,'w');
   fwrite(fid,mystr);
   fclose(fid);

return
end
function save(self, varargin);
   % \date 09-10-2014 by M.Moriche \n
   %       sort indxlist
   
   indxlist = self.getindxlist('ResultsItem');
   misc.assigndefaults(varargin{:});

   indxlist = sort(indxlist);

   objectspath = self.objectspath;
   notespath   = self.notespath;
   ansysnm = self.ansysnm;

   system(sprintf('mkdir -p %s' , objectspath ));
   system(sprintf('mkdir -p %s' , fullfile(objectspath, ansysnm )));

   display(sprintf('saving %s items in %s',ansysnm,objectspath));
   display(' ')
   display(sprintf('%10s%40s%40s','Index','Caption','Global caption'))
   display(' ')

   %editcap = @(cap) strrep(strrep(cap,'\_','_'),'\newline',' ');
   editcap = @(cap) strrep(cap,'\newline',' ');
   for i = 1:length(indxlist)
      indx = indxlist(i);
      item = self.getitembyindx(indx);
      item = item{1};
      item.save(objectspath,ansysnm, varargin{:},'notespath', notespath);
   end


return
end

function indx = finduniqueindx(self, classname, indx);

   indxlist = self.getindxlist(classname);
   while find(indxlist == indx) 
      indx = indx + 1;
   end

return
end

function fnm = getREADMEfnm(self)
   fnm = sprintf('%s/%s.README',self.objectspath,self.ansysnm);
return
end

function appendToREADME(self, mycontent, varargin)

   title = '*';
   misc.assigndefaults(varargin{:});

   ln = ''; for i = 1:80, ln = [ln '_']; end

   fnm =  self.getREADMEfnm();
   fid = fopen(fnm, 'a');
   fprintf(fid, ['\n\n' ln '\n'] );
   if ~strcmp(title,'*')
      fprintf(fid, [title '\n'] );
      fprintf(fid, [ln '\n\n']);
   end
   fwrite(fid, mycontent);
   fclose(fid);
return
end

end % methods
end % class
