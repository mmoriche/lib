classdef Data  < ResultsItem

properties
frmtlist
hfrmtlist
varlist
joiner
multiflag
end

methods

function self = Data(buffer, indx, cap, glb, varargin)

   varlist = '*';
   multiflag = '*';
   %frmtlist  = cell(size(buffer,2),1);
   %hfrmtlist = cell(size(buffer,2),1);
   frmtlist  = {'*'};
   hfrmtlist = {'*'};
   joiner = '';
   auxfiles=true;
   misc.assigndefaults(varargin{:});
   if strcmp(varlist,'*')
      varlist = {};
      for i1 = 1:size(buffer,2)
         varlist = [varlist {sprintf('data_%d', i1)}];
      end
   end
   % format list
   if ~strcmp(hfrmtlist{1}, '*')
      for i1 = 1:size(buffer,2)
         if isempty(hfrmtlist{i1})
            hfrmtlist{i1} = '%18s';
         end
      end
   end
   % format list
   if ~strcmp(frmtlist{1}, '*')
      for i1 = 1:size(buffer,2)
         if isempty(frmtlist{i1})
            frmtlist{i1} = '%18.8E';
         end
      end
   end

   self@ResultsItem(buffer, indx, cap, glb,'auxfiles',auxfiles)
   self.hfrmtlist  =hfrmtlist;
   self.frmtlist   = frmtlist;
   self.varlist    = varlist;
   self.joiner     = joiner;
   self.multiflag  = multiflag;

return
end

function filelist = save(self,objectspath,ansysnm,varargin)

   % DEFAULTS
   frmt = 'data';
   misc.assigndefaults(varargin{:});

   fnm = self.getfullfilename(objectspath, ansysnm);

   self.hfrmtlist;
   self.varlist;
   self.frmtlist;
   self.joiner;
   % save table
   ftab = [fnm '.' frmt];
   fid = fopen(ftab, 'w');

   n = size(self.handle,2);
   
   if ~strcmp(self.hfrmtlist{1}, '*')
       disp('hola')
       n
      for i1 = 1:(n-1)
         fprintf(fid,self.hfrmtlist{i1}, self.varlist{i1});
         fprintf(fid,self.joiner);
   %      self.hfrmtlist{i1}
   %      self.varlist{i1}
      end
      fprintf(fid,self.hfrmtlist{n}, self.varlist{n});
      fprintf(fid,'\n');
   end

   if strcmp(class(self.handle), 'cell')
      for i0 = 1:size(self.handle,1)
         n = size(self.handle,2);
         for i1 = 1:(n-1)
            fprintf(fid,self.frmtlist{i1}, self.handle{i0,i1});
            fprintf(fid,self.joiner);
         end
         fprintf(fid,self.frmtlist{n}, self.handle{i0,n});
         fprintf(fid,'\n');
      end
   else
      newfrmt = '';
      n = size(self.handle,2);
      for i1 = 1:(n-1)
         newfrmt = [newfrmt self.frmtlist{i1} self.joiner];
      end
      newfrmt = [newfrmt self.frmtlist{n} '\n'];
      if strcmp(self.multiflag, '*')
         fprintf(fid,newfrmt, self.handle');
      else
         ia = 1;
         if isnan(self.multiflag)
            ib = find(isnan(self.handle(ia:end,1)));
         else
            ib = find(self.handle(ia:end,1) == self.multiflag);
         end
         if ~isempty(ib)
            ib = ib(1)-1;
         else
            ib = size(self.handle,1);
         end
         while ia<size(self.handle,1)

            fprintf(fid,newfrmt, self.handle(ia:ib,:)');
            fprintf(fid,'\n');

            ia = ib+2;
            if isnan(self.multiflag)
               ib = find(isnan(self.handle(ia:end,1)));
            else
               ib = find(self.handle(ia:end,1) == self.multiflag);
            end
            if ~isempty(ib)
               ib = (ia-1)+ib(1)-1;
            else
               ib = size(self.handle,1);
            end
         end
      end
   end
   fclose(fid);

   % save caption and global caption
   filelist_2 = save@ResultsItem(self,objectspath,ansysnm);
   filelist = cat(1, {ftab}, filelist_2);

return
end

end

end
