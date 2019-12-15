function mystr = tab2ascii_help(table,varargin)
%function mystr = tab2ascii_md(table,varargin)
%
% Optional parameters:
% HA='r': Horizontal Alignment, possible values:
%   - 'r': right
%   - 'l': left
%
validTable = @(x) iscell(x) && ndims(x)==2;
validHA = @(x) nnz(x=='rl')==1;
defaultHA='r';

p=inputParser();
addRequired(p,'table',validTable);
addOptional(p,'HA',defaultHA,validHA);
parse(p,table,varargin{:});
HA=p.Results.HA;

%cap = [];
%misc.assigndefaults(varargin{:});

% get max width per column
[nrows,ncols]=size(table);
nmax = zeros(ncols, 1);
for i = 1:nrows
   for j = 1:ncols
      n=length(table{i,j});
      if n > nmax(j)
         nmax(j)=n;
      end
   end
end
nmax = nmax + 2;

mystr = '';
%mystr = hlinetop(mystr,ncols,nmax);
mystr = row(mystr,1,table,ncols,nmax);
mystr = hline(mystr,ncols,nmax);
for i = 2:nrows
   mystr = row(mystr,i,table,ncols,nmax,'HA',HA);
end
%mystr = hlinebot(mystr,ncols,nmax);

%if ~isempty(cap)
%   mystr = hcap(mystr,cap,ncols,nmax);
%end

return 
end

%________________________________________________________________________________

function mystr = hcap(mystr,cap,ncols,nmax)


nn = sum(nmax(:));
myfrmt = ['%' num2str(nn) 's'];
mystr = [mystr sprintf(myfrmt, cap) sprintf('\n')];

for j = 1:ncols
   mystr = [mystr '~'];
   for j2 = 1:nmax(j)
      mystr = [mystr '~'];
   end
end
mystr = [mystr '~' sprintf('\n')];
return 
end
%________________________________________________________________________________

function mystr = hline(mystr,ncols,nmax)

mystr=[mystr '% '];
for j = 1:ncols
   if j == 1
      %mystr = [mystr '├'];
      mystr = [mystr '|'];
   else
      %mystr = [mystr '┼'];
      mystr = [mystr '|'];
   end
   for j2 = 1:nmax(j)
      %mystr = [mystr '─'];
      mystr = [mystr '-'];
   end
end
%mystr = [mystr '|' sprintf('\n')];
mystr = [mystr '|' sprintf('\n')];
return 
end
function mystr = hlinebot(mystr,ncols,nmax)

for j = 1:ncols
   if j == 1
      %mystr = [mystr '└'];
      mystr = [mystr '+'];
   else
      %mystr = [mystr '┴'];
      mystr = [mystr '-'];
   end
   for j2 = 1:nmax(j)
      %mystr = [mystr '─'];
      mystr = [mystr '-'];
   end
end
%mystr = [mystr '┘' sprintf('\n')];
mystr = [mystr '+' sprintf('\n')];
return 
end

function mystr = hlinetop(mystr,ncols,nmax)

for j = 1:ncols
   if j == 1
      %mystr = [mystr '┌'];
      mystr = [mystr '+'];
   else
      %mystr = [mystr '┬'];
      mystr = [mystr '+'];
   end
   for j2 = 1:nmax(j)
      %mystr = [mystr '─'];
      mystr = [mystr '-'];
   end
end
%mystr = [mystr '┐' sprintf('\n')];
%mystr = [mystr '+' sprintf('\n')];
return 
end

%________________________________________________________________________________
function mystr = row(mystr,i,table,ncols,nmax,varargin)
%
validHA = @(x) nnz(x=='rl')==1;
defaultHA='r';

p=inputParser();
addRequired(p,'mystr');
addRequired(p,'i');
addRequired(p,'table');
addRequired(p,'ncols');
addRequired(p,'nmax');
addOptional(p,'HA',defaultHA,validHA);
parse(p,mystr,i,table,ncols,nmax,varargin{:});
HA=p.Results.HA;

if strcmp(HA,'r')
   mys='%';
elseif strcmp(HA,'l')
   mys='%-';
end

if i > 1
   mystr=[mystr '% '];
end
for j = 1:ncols
   %mystr=[mystr '│'];
   mystr=[mystr '|'];
   myfrmt = [mys num2str(nmax(j)-1) 's'];
   uu = table{i,j};
   mystr  = [mystr sprintf(myfrmt , uu) ' '];
end
%mystr = [mystr '│' sprintf('\n')];
mystr = [mystr '|' sprintf('\n')];
return
end
