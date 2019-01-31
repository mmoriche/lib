classdef Table  < ResultsItem

properties
halign
type
islong
end

methods

function self = Table(tab, indx, cap, glb, varargin)

   halign = '*';
   type = 'open';
   islong = false;
   misc.assigndefaults(varargin{:});

   self@ResultsItem(tab, indx, cap, glb)
   self.halign = halign;
   self.type   = type;

return
end

function filelist = save(self,objectspath,ansysnm,varargin)

   % DEFAULTS
   frmt = 'tex';
   misc.assigndefaults(varargin{:});

   fnm = self.getfullfilename(objectspath, ansysnm);

   % save table
   ftab = [fnm '.' frmt];
   fid = fopen(ftab,'w');
   fwrite(fid,mytab.tab2tex(self.handle,'halign',self.halign, ...
                                        'type', self.type,    ...
                                        'islong', self.islong));
   fclose(fid);
    
   % save caption and global caption
   filelist_2 = save@ResultsItem(self,objectspath,ansysnm);
   filelist = cat(1, {ftab}, filelist_2);

return
end

end

end
