function helpdoc(myfile,README,filemode,itank,ifnmlist,otank,ofnmlist)
%
%
% @example (inside script)
%
% thisfile=[mfilename('fullpath'),'.m'];
% README = fullfile(otank,[mfilename '.README']);
% misc.helpdoc(thisfile,README);
%



fid=fopen(README,filemode);

nt = 80;
ln = ''; for i = 1:nt, ln = [ln '_']; end
% get help of file, machine and date
[istat,thismachine]=system('uname -n');

fid2=fopen(myfile,'r');
firstchar=char(fread(fid2,1,'char'));
% WRITE FIRST COMMENTS TO fid
fprintf(fid, ['\n' ln '\n\n']);
% readme
fprintf(fid, 'this README:\n');
nleft=length(README);
nwrite=round(nleft)/nt;
ia=1;
while nleft>0
   ib=ia+min(nt,nleft)-1;
   fprintf(fid,' %s\n', README(ia:ib));
   nleft=length(README)-ib;
   ia=ia+nt;
end
fprintf(fid, 'script:\n');
nleft=length(myfile);
nwrite=round(nleft)/nt;
ia=1;
while nleft>0
   ib=ia+min(nt,nleft)-1;
   fprintf(fid,' %s\n', myfile(ia:ib));
   nleft=length(myfile)-ib;
   ia=ia+nt;
end
%
fprintf(fid, '\nrun on %s on %s\n', thismachine(1:end-1), date);
fprintf(fid, [ln '\n\n']);
pat='.*<(.*)>.*';
pattharr='-(.*)-';
pattvarr='\|(.*)\|';
pattvarrfull='<\|(.*)\|>';
while firstchar == '%'
   ln0=fgets(fid2);
   tkns=regexp(ln0,pat,'tokens');
   if isempty(tkns)
      fprintf(fid,ln0);
   else
      while ~isempty(tkns)
         ln1=ln0;
         for i3=1:length(tkns)
            varnm=tkns{i3}{1};
            tknsharr=regexp(varnm,pattharr,'tokens');
            tknsvarr=regexp(varnm,pattvarr,'tokens');
            if ~isempty(tknsharr)
               varnmarr=tknsharr{1}{1};
               var  =evalin('caller',varnmarr);
               mystr=['[',misc.strjoin(var,','),']']
            elseif ~isempty(tknsvarr)
               varnmarr=tknsvarr{1}{1};
               tknsext=regexp(ln0,pattvarrfull,'tokenExtents');
               nchars=diff(tknsext{1})+1;
               nchars=tknsext{1}(1)-2;
               ee='';
               for i5=1:nchars, ee=[ee,' ']; end
               var  =evalin('caller',varnmarr);
               mystr=['[',misc.strjoin(var,[',\n',ee]),']']
            else
               var  =evalin('caller',varnm);
               mystr=string(var);
            end
            ln1=strrep(ln1,['<' varnm '>'], mystr);
         end
         ln0=ln1;
         tkns=regexp(ln0,pat,'tokens');
      end
      fprintf(fid,ln1);

   end
   firstchar=char(fread(fid2,1,'char'));
end
fclose(fid2);

if nargin>3

   fprintf(fid, '\nFiles used:\n\n');
   fnmlist2={};
   fnmlist2=cat(1,fnmlist2,['I=' itank]);
   for i1=1:length(ifnmlist)
      fnmlist2=cat(1,fnmlist2,...
               strrep(ifnmlist{i1},[itank '/'],'I:'));
   end
   fprintf(fid,mytab.tab2ascii_md(fnmlist2,'HA','l'));

end

if nargin>5
   fprintf(fid, '\nFiles generated:\n\n');
   fnmlist2={};
   fnmlist2=cat(1,fnmlist2,['O=' otank]);
   for i1=1:length(ofnmlist)
      fnmlist2=cat(1,fnmlist2,...
               strrep(ofnmlist{i1},[otank '/'],'O:'));
   end
   fprintf(fid,mytab.tab2ascii_md(fnmlist2,'HA','l'));
end

fclose(fid);
return
end

