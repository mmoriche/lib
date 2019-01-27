function mystr = tab2tex(tab,varargin)
% @author M.Moriche
% @date 17-12-2013 by M.Moriche \n
%       Documented.
% @date 22-10-2014 by M.Moriche \n
%       Added optional argument halign.
%
% @brief function to generate latex string to represent a table
%        with the cells from cell $tab
%
% @details
%
% Output
% - mystr: string with the latex format for a tabular environment
%
% Mandatory arguments
% - tab: 2 dimensonal cell with strings to be used in the latex table
%
% OPTIONAL ARGUMENTS:
% - halign: text string indicating the horizontal alignment
%
%
% Example:
% @code
% >> tab = [{'case','data'};{'a1','Low'};{'b1','High'} ]
% 
% tab = 
% 
% 'case'    'data'
% 'a1'      'Low' 
% 'b1'      'High'
% 
% >> mystr = mytab.tab2tex(a)
% 
% mystr =
% 
% \begin{tabular}{cc} 
% case & data  \\
% \hline 
% a1 & Low  \\
% b1 & High  \\
% \end{tabular}
%  
% @endcode
%

% DEFAULTS...
halign = '*';
type='open';
islong = false;
misc.assigndefaults(varargin{:});

if strcmp(type,'open')
   sidebar = '';
   topbar = '\n';
end
if strcmp(type,'closed')
   sidebar = '|';
   topbar = '\\hline\n';
end

if strcmp(halign,'*')
   halign = sidebar;
   for i = 1:length(tab(1,:))
      halign = [halign 'c'];
   end
   halign = [halign sidebar];
end
%---------------------------------

header = tab(1,:);
rows = tab(2:end,:);

ncols=length(header);
nrows=size(rows,1);
%
%headerpos='';
%for i =1:ncols
    %headerpos = [headerpos halign(i)];
%end
headerpos = halign;
%
if islong
   mystr = sprintf('%s{longtable}{%s} \n','\begin', headerpos);
else
   mystr = sprintf('%s{tabular}{%s} \n','\begin', headerpos);
end

mystr = [mystr sprintf(topbar)];

for j = 1:ncols-1
  mystr = [mystr header{j} ' & '];
end
mystr = [mystr header{end} '  \\' sprintf('\n')];
%
mystr = [mystr '\hline ' sprintf('\n')];
%
for i = 1:nrows
   for j = 1:ncols-1
     mystr = [mystr rows{i,j} ' & '];
   end
   mystr = [mystr rows{i,end} '  \\' sprintf('\n')];
end
mystr = [mystr sprintf(topbar)];
if islong
   mystr = [mystr '\end{longtable}'];
else
   mystr = [mystr '\end{tabular}'];
end
%
return
end
