function str = genlegend(figlist, cap, varargin)

figscale=0.2;
misc.assigndefaults(varargin{:});
pat = '<(\S*?)>';
aa = regexp(cap, pat, 'tokens')

str = cap;
for i1 = 1:length(aa)
   label = aa{i1}{1};
   i2 = 0;
   while true
      i2 = i2 + 1;
      ltex = gentexstr(figlist(i2), label, varargin{:}); 
      if ~isempty(ltex), break, end
   end
   str = strrep(str, ['<' label '>'], ltex);
end

return
end

%-------------------------------------------------------------------------------
function str = gentexstr(fig, tag, varargin)


% default scale
figscale = 0.2;
misc.assigndefaults(varargin{:});

ll = findobj(fig, 'Tag', tag);
if isempty(ll)
   display(['Tag ' tag '  NOT FOUND'])
   str = '';
   return
elseif length(ll) > 1
   display(' -- ')
   display(' -- ')
   display(['Multiple tags with same name ' tag ])
   display(' -- ')
   display(' -- ')
   ll = ll(1);
end

%vv = version('-release');
%vv = str2num(vv(1:4));
%if vv < 2014
%   ll = get(ll);
%end
ll = get(ll);

lw = ll.LineWidth/72*figscale;
[mark ms] = getlatexmark(ll,'figscale',figscale);

latexfun = 'lineSymbolRGB';

linestyle = getlatexstyle(ll);
if isfield(ll,'Color')
   rgb = ll.Color;
elseif isfield(ll,'LineColor')
   rgb = ll.LineColor;
elseif isfield(ll,'FaceColor')
   rgb = ll.FaceColor;
end
cc = ['{' misc.strjoin(rgb, '}{') '}'];
str = ['\' latexfun '[' linestyle ']' cc ...
       '{' num2str(lw) 'in}' ...
       '{' mark '}' ...
       '{' num2str(ms) 'in}'  ];

return
end

%-------------------------------------------------------------------------------
function [mm ms] = getlatexmark(linehandle, varargin)

% default scale
figscale = 0.2;
misc.assigndefaults(varargin{:});

if isfield(linehandle,'Marker')
   matlabmark = linehandle.Marker;
   markface   = linehandle.MarkerFaceColor;
else
   matlabmark = 'none';
end
if strcmp(matlabmark, 'none')
   mm = 'none';
   ms = '0';
else
   if strcmp(matlabmark, 'o')
      mm = 'o';
   elseif strcmp(matlabmark, 'square')
      mm = 's';
   elseif strcmp(matlabmark, '^')
      mm = 't';
   elseif strcmp(matlabmark, 'v')
      mm = 'bt';
   elseif strcmp(matlabmark, '>')
      mm = 'rt';
   end
   ms = linehandle.MarkerSize/72*figscale;
   if ~strcmp(markface, 'none')
      mm = [mm '*'];
   end
end


return
end

%-------------------------------------------------------------------------------
function mm = getlatexstyle(linehandle)

matlabstyle = linehandle.LineStyle;
mm = 'none';
if strcmp(matlabstyle, '-')
   mm = 'solid';
elseif strcmp(matlabstyle, '--')
   mm = 'dashed';
end

return
end
