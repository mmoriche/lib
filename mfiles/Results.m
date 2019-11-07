classdef Results  < dynamicprops
% 
% @author M.Moriche
% @brief Class to handle post-processing of results
% @date 18-05-2014 by M.Moriche \n
%       Created
% @date 03-12-2014 by M.Moriche \n
%       indx as output for the addItem
% @date 03-04-2016 by M.Moriche \n
%       filelist as output for method save of any results item
% @date 01-06-2017 by M.Moriche \n
%       Added capnm and glbnm to decorate tables
%
% @details
%
% properties
%
% auxfiles: set to false if no cap,glb or data directory is to be saved
% 
% - EXAMPLES:
%
% @code
% rs = Results('analsysis','/dir/to/figsandtabs');
% rs.addXYPlot(fig, 'indx', 1, 'cap', 'hola', 'glb','adios');
% rs.save();
%
% rs = Results('analsysis','/dir/to/figsandtabs','capnm','t/T','glbnm','quantity');
% rs.addXYPlot(fig, 'indx', 1, 'cap', 'hola', 'glb','adios');
% rs.save();
% @endcode
properties
   ansysnm
   objectspath
   items        % list with post-processed items
   indices
   savedindx
   savedfiles
   glbnm
   capnm
   auxfiles
   skipexisting
end

methods
function self = Results(ansysnm, objectspath, varargin)
   %
   %
   %  MANDATORY ARGUMENTS:
   %  - ansysnm: reference name of the analysis
   %  - objectspath: path where figures and tables are to be saved
   %
   %
   capnm = 'Caption';
   glbnm = 'Global Cap.';
   auxfiles=true;
   skipexisting=false;
   misc.assigndefaults(varargin{:});
   self.ansysnm     = ansysnm;
   self.objectspath = objectspath;
   self.capnm = capnm;
   self.glbnm = glbnm;
   self.auxfiles = auxfiles;
   self.skipexisting = skipexisting;
  
   self.items   = {};
   self.indices = [];
   self.savedindx = [];

return
end

function indx = addData(self, buffer, varargin)

   indx = 1;
   cap = ' '; 
   glb = ' ';
   tex = ' ';
   multiflag = '*';
   %hfrmtlist = cell(size(buffer, 2), 1);
   %frmtlist = cell(size(buffer, 2), 1);
   hfrmtlist = {'*'};
   frmtlist = {'*'};
   varlist = '*';
   joiner = '';
   auxfiles = self.auxfiles;
   misc.assigndefaults(varargin{:});

   frmtlist
   indx = self.finduniqueindx('ResultsItem',indx);
   item = Data(buffer,indx, cap, glb, ...
    'hfrmtlist', hfrmtlist, 'varlist', varlist, 'frmtlist', frmtlist, ...
    'auxfiles',auxfiles,'joiner',joiner, 'multiflag', multiflag);
   
   self.items = [self.items {item}];
   self.indices = [self.indices indx];

return
end

function indx = addXYPlot(self, handle, varargin)

   indx = 1;
   cap = ' '; 
   glb = ' ';
   tex = ' ';
   legendjoiner = ', ';
   scale = 0.4;
   papercolor = 'w';
   auxfiles = self.auxfiles;
   misc.assigndefaults(varargin{:});

   indx = self.finduniqueindx('ResultsItem',indx);
 
   item = XYPlot(handle,indx, cap, glb, tex, ...
    'legendjoiner', legendjoiner, 'scale', scale, ...
    'papercolor', papercolor, 'auxfiles',auxfiles); 
   
   self.items = [self.items {item}];
   self.indices = [self.indices indx];

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
   self.indices = [self.indices indx];

return
end

function indx = addCONTOURPlot(self, handle, varargin)

   indx = 1;
   cap = ' '; 
   glb = ' ';
   legendjoiner = ', ';
   scale = 1;
   misc.assigndefaults(varargin{:});

   indx = self.finduniqueindx('ResultsItem',indx);
 
   item = CONTOURPlot(handle,indx, cap, glb, 'legendjoiner', legendjoiner, 'scale', scale); 
   
   self.items = [self.items {item}];
   self.indices = [self.indices indx];

return
end

function indx = addTable(self, table, varargin)

   indx = 1;
   cap = ' '; 
   glb = ' ';
   halign = '*';
   type = 'open';
   islong = false;
   misc.assigndefaults(varargin{:});

   indx = self.finduniqueindx('ResultsItem',indx);
 
   item = Table(table,indx, cap, glb,'halign',halign, 'type',type, 'islong', islong); 
   
   self.items = [self.items {item}];
   self.indices = [self.indices indx];

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
   
   ii = find(indx == self.indices);
   item = self.items(ii);
   %indxlist = self.getindxlist('ResultsItem');
   %for i = 1:length(indxlist)
   %    indx1 = indxlist(i);
   %    if indx1 == indx
   %       item = self.items(i);
   %       break
   %    end
   %end
   
return
end

function summ(self, varargin);
   % \date 09-10-2014 by M.Moriche \n
   %       sort indxlist
   longtable=false;
   misc.assigndefaults(varargin{:});
   
   indxlist = self.getindxlist('ResultsItem');
   indxlist = sort(indxlist);

   objectspath = self.objectspath;
   ansysnm = self.ansysnm;

   system(sprintf('mkdir -p %s' , objectspath ));
   system(sprintf('mkdir -p %s' , fullfile(objectspath, ansysnm )));

   tab = cell(1,4);
   %tab(1,:) = {'Object','index', 'caption','Global caption'};
   tab(1,:) = {'Object','index', self.capnm, self.glbnm};
   editcap = @(cap) strrep(cap,'\newline',' ');
   nl = sprintf('\n');
   for i = 1:length(indxlist)
      indx = indxlist(i);
      item = self.getitembyindx(indx);
      item = item{1};
      flag = item.summ;
      if flag
         tab(i+1,:) = {class(item),num2str(item.indx),editcap(strrep(item.cap,nl,' ')),...
                                                      editcap(strrep(item.glb,nl,' '))};
      end
   end

   if longtable
      mystr = mytab.tab2ascii_md(tab,'cap',self.ansysnm);
   else
      mystr = mytab.tab2ascii2_md(tab,[10,7,26,26],'cap',self.ansysnm);
   end
   display(mystr)

   fnm = self.getREADMEfnm();
   fid = fopen(fnm,'w');

   nt = 80;
   ln = ''; for i = 1:nt, ln = [ln '_']; end
   % get help of file, machine and date
   [istat,thismachine]=system('uname -n');
   aa=dbstack('-completenames');
   caller_file=aa(2).file
   fid2=fopen(caller_file,'r');
   firstchar=char(fread(fid2,1,'char'));
   % WRITE FIRST COMMENTS TO README
   fprintf(fid, ['\n' ln '\n\n']);
   fprintf(fid, 'script:\n%s\n', caller_file);
   fprintf(fid, 'run at %s on %s\n', thismachine(1:end-1), date);
   while firstchar == '%'
      fprintf(fid,fgets(fid2));
      firstchar=char(fread(fid2,1,'char'));
   end
   fclose(fid2);
   fprintf(fid,'\n\n');
   fprintf(fid, [ln '\n\n']);
   fprintf(fid,'OBJECTS GENERATED AT:\n');
   fprintf(fid,[fullfile(objectspath,ansysnm) '\n']);
   system(sprintf('mkdir -p %s' , fullfile(objectspath, ansysnm )));
   fwrite(fid,mystr);
   fprintf(fid, ['\n' ln '\n\n']);
   fclose(fid);

return
end

function save(self, varargin);

   % \date 09-10-2014 by M.Moriche \n
   %       sort indxlist
   
   indxlist = self.getindxlist('ResultsItem');
   indxlist0 = indxlist;
   force = false;
   misc.assigndefaults(varargin{:});

   indxlist = sort(indxlist);

   objectspath = self.objectspath;
   ansysnm = self.ansysnm;

   system(sprintf('mkdir -p %s' , objectspath ));
   system(sprintf('mkdir -p %s' , fullfile(objectspath, ansysnm )));

   if length(indxlist) == length(indxlist0) || indxlist(1) == indxlist0(1)
      display(sprintf('saving %s items in %s',ansysnm,objectspath));
   end

   editcap = @(cap) strrep(cap,'\newline',' ');
   for i = 1:length(indxlist)

      indx = indxlist(i);
      if isempty(find(self.savedindx == indx)) | force
         item = self.getitembyindx(indx);
         item = item{1};
         filelist = item.save(objectspath,ansysnm, varargin{:},'skipexisting',self.skipexisting);
         self.savedindx = cat(1, self.savedindx, indx);
         self.savedfiles = cat(1, self.savedfiles, filelist);
      end
   end


return
end

function saveraw(self, varargin);
   % \date 09-10-2014 by M.Moriche \n
   %       sort indxlist
   
   indxlist = self.getindxlist('ResultsItem');
   misc.assigndefaults(varargin{:});

   indxlist = sort(indxlist);

   objectspath = self.objectspath;
   ansysnm = self.ansysnm;

   system(sprintf('mkdir -p %s' , objectspath ));

   display(sprintf('RAW saving %s items in %s',ansysnm,objectspath));
   display(' ')
   display(sprintf('%10s%40s%40s','Index','Caption','Global caption'))
   display(' ')

   editcap = @(cap) strrep(cap,'\newline',' ');
   for i = 1:length(indxlist)

      indx = indxlist(i);
      if isempty(find(self.savedindx == indx))
         item = self.getitembyindx(indx);
         item = item{1};
         filelist = item.saveraw(objectspath,ansysnm, varargin{:});
         self.savedindx = cat(1, self.savedindx, indx);
         self.savedfiles = cat(1, self.savedfiles, filelist);
      end
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

   %nt = 80 - length(title) - 1;
   nt = 80;
   ln = ''; for i = 1:nt, ln = [ln '_']; end

   fnm =  self.getREADMEfnm();
   fid = fopen(fnm, 'a');
   fprintf(fid, '\n\n');
   fwrite(fid, ln);
   fprintf(fid, '\n\n' );
   if ~strcmp(title,'*')
      fwrite(fid, title);
      fprintf(fid, '\n' );
      fwrite(fid, ln );
      %fprintf(fid, ln );
      fprintf(fid, '\n\n');
   end
   fwrite(fid, mycontent);
   %fprintf(fid, mycontent);
   fclose(fid);

   disp(ln)
   disp(title)
   disp(ln)
   disp(mycontent)

return
end

function showlegends(self)
   indxlist = self.getindxlist('MatlabFigure')
   for i = 1:length(indxlist)
       item = self.getitembyindx(indxlist(i))
       set(0, 'CurrentFigure', item{1}.handle)
       legend('toggle')
   end
return
end

function mydir = getdirectory(self)

    mydir = fullfile(self.objectspath, self.ansysnm);

return
end

function clean(self, varargin)

   safe = true;
   misc.assigndefaults(varargin{:});
   
   filestodelete = {};
   filesindir = {};
   mydir = self.getdirectory();
   D = misc.rdir(fullfile(mydir, '**','*'));
   for ii=1:length(D), filesindir{ii} = D(ii).name; end;

   for ii = 1:length(filesindir)
      indxok = find(strcmp(filesindir{ii}, self.savedfiles));
      if isempty(indxok)
         filestodelete = [filestodelete filesindir{ii}];
      end
   end

   if safe
      if ~isempty(filestodelete)
      'There are files not generated in this Results action '
      'the following files would be deleted:'
      for ii = 1:length(filestodelete)
        display(filestodelete{ii})
      end
      myflag = input(' Click 1 to confirm, 0 to not delete');
      if myflag == 1
        for ii = 1:length(filestodelete)
          system(sprintf('rm -r %s',  filestodelete{ii}));
        end
      end
      end
   else
      if ~isempty(filestodelete)
      'There are files not generated in this Results action '
      'the following files would be deleted:'
      for ii = 1:length(filestodelete)
       display(filestodelete{ii})
      end
      for ii = 1:length(filestodelete)
        system(sprintf('rm -r %s',  filestodelete{ii}));
      end
      end
   end



return
end

end % methods
end % class
