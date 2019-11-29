function helpdoc(myfile,fid,itank,ifnmlist,otank,ofnmlist)
%
%
% @example (inside script)
%
% thisfile=[mfilename('fullpath'),'.m'];
% README = fullfile(otank,[mfilename '.README']);
% misc.helpdoc(thisfile,README);
%


nt = 80;
ln = ''; for i = 1:nt, ln = [ln '_']; end
% get help of file, machine and date
[istat,thismachine]=system('uname -n');

fid2=fopen(myfile,'r');
firstchar=char(fread(fid2,1,'char'));
% WRITE FIRST COMMENTS TO fid
fprintf(fid, ['\n' ln '\n\n']);
fprintf(fid, 'script:\n%s\n', myfile);
fprintf(fid, 'run at %s on %s\n\n\n', thismachine(1:end-1), date);
pat='.*<(.*)>.*';
while firstchar == '%'
   ln0=fgets(fid2);
   tkns=regexp(ln0,pat,'tokens');
   if isempty(tkns)
      fprintf(fid,ln0);
   else
      while ~isempty(tkns)
         ln1=ln0;
         for i3=1:length(tkns)
            ln1=strrep(ln1,['<' tkns{i3}{1} '>'], ...
                string(evalin('caller',tkns{i3}{1})));
         end
         ln0=ln1;
         tkns=regexp(ln0,pat,'tokens');
      end
      fprintf(fid,ln1);

   end
   firstchar=char(fread(fid2,1,'char'));
end
fclose(fid2);

if nargin>2

   fprintf(fid, '\nFiles used:\n\n');
   fnmlist2={};
   fnmlist2=cat(1,fnmlist2,['I=' itank]);
   for i1=1:length(ifnmlist)
      fnmlist2=cat(1,fnmlist2,...
               strrep(ifnmlist{i1},[itank '/'],'I:'));
   end
   fprintf(fid,mytab.tab2ascii_md(fnmlist2,'HA','l'));

end

if nargin>4
   fprintf(fid, '\nFiles generated:\n\n');
   fnmlist2={};
   fnmlist2=cat(1,fnmlist2,['O=' otank]);
   for i1=1:length(ofnmlist)
      fnmlist2=cat(1,fnmlist2,...
               strrep(ofnmlist{i1},[otank '/'],'O:'));
   end
   fprintf(fid,mytab.tab2ascii_md(fnmlist2,'HA','l'));
end


return
end

