classdef ResultsItem  < dynamicprops
% \date 03-04-2016 by M.Moriche \n
%       Added filelist as ouptut for save method


properties

% Matlab Object or handle
handle
% index
indx
% caption
cap
% global caption
glb
%
auxfiles
%
summ
%
end
methods
function self = ResultsItem(handle, indx, cap, glb, varargin)
   auxfiles=true;
   summ = true;
   misc.assigndefaults(varargin{:});
   self.handle = handle;
   self.indx = indx;
   self.cap = cap;
   self.glb = glb;
   self.auxfiles = auxfiles;
   self.summ = summ;
return
end
   
function fnm = getfullfilename(self, objectspath, ansysnm)

   fnm = sprintf('%s/%s/%s_%d',objectspath, ansysnm, ansysnm, self.indx);

return
end

function fnm = getfilename(self, ansysnm)

   fnm = sprintf('%s_%d',ansysnm, self.indx);

return
end

function fnm = getpathname(self, ansysnm)

   fnm = fullfile(ansysnm,sprintf('%s_%d',ansysnm, self.indx));

return
end

function fnm = getdatadir(self, objectspath, ansysnm)

   fnm1 = self.getfullfilename(objectspath, ansysnm);
   fnm = sprintf('%s_data', fnm1);

return
end

function fnm = getfullfilename2(self, objectspath, ansysnm)

   fnm1 = self.getdatadir(objectspath, ansysnm);
   fnm2 = self.getfilename(ansysnm);
   fnm = fullfile(fnm1, fnm2);

return
end

function filelist = save(self,objectspath, ansysnm)

    if self.auxfiles
       datadir = self.getdatadir(objectspath, ansysnm);
       fnm = self.getfilename(ansysnm);

       system(sprintf('mkdir -p %s', datadir));

       fcap = fullfile(datadir, [fnm '.cap']);
       fid = fopen(fcap,'w');
       fwrite(fid, self.cap);
       fclose(fid);
   
       fglb = fullfile(datadir, [fnm '.glb']);
       fid = fopen(fglb,'w');
       fwrite(fid, self.glb);
       fclose(fid);

       %display(sprintf('%10d%40s%40s',self.indx, self.cap, self.glb))
       filelist = {datadir;fcap;fglb};
    else
       filelist = {};
    end

return
end

function filelist = saveraw(self,objectspath, ansysnm)

    datadir = objectspath;
    fnm = self.getfilename(ansysnm);

    system(sprintf('mkdir -p %s', datadir));

    %fcap = fullfile(datadir, [fnm '.cap']);
    %fid = fopen(fcap,'w');
    %fwrite(fid, self.cap);
    %fclose(fid);
   
    %fglb = fullfile(datadir, [fnm '.glb']);
    %fid = fopen(fglb,'w');
    %fwrite(fid, self.glb);
    %fclose(fid);

    %display(sprintf('%10d%40s%40s',self.indx, self.cap, self.glb))
    filelist = {datadir};

return
end

end
end
