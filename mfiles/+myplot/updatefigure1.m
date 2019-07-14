function varargout = updatefigure1(fig, varargin)
%
%
% LineWidths in matlab are given by 1Points= 1/72 inches
%  
% Actual line widths that look ok:
%     0.002 thin line
%     0.004 normal line
%     0.008 thick line
%
% defaults
%
% xflag = true;    --> boolean indicating if there is x axis
% yflag = true;    --> boolean indicating if there is y axis
% zflag = true;    --> boolean indicating if there is z axis
% axequal = false; --> boolean that set axis equal manually
% 
%     +-------------------+
%     |        hx         |
%     |    +----------+   |
%     | wa |      pryr| wx|
%     |    |   prxr   |   |
%     |    +----------+   |
%     |       ha          |
%     +-------------------+
%
% prxr = -1;       --> Width of axes  (if -1, set to 2.4 in)
% pryr = -1;       --> Height of axes (if -1, set to prxr/aurea)
% wa = 0.4; wx = 0.1;  --> Width  label and extra space
% ha = 0.4; hx = 0.1;  --> Height label and extra space
% fsxf = 1;      --> Scale for x label font size
% fsyf = 1;      --> Scale for y label font size
% fscf = 1;      --> Scale for colorbar label font size
% rotation=0;    --> rotation of the ylabel (in degrees)
% figscale=0.2;  --> scale to represent the figure in the documennt
% fstick = 8;    --> axes tick label font size
% fslabel = 10;  --> axes labels font size (and legend)
% axwdith=
xflag = true;
yflag = true;
zflag = true;
prxr = -1;
pryr = -1;
axequal = false;
axtransposed = false;
wa = 0.4; wx = 0.1;
ha = 0.4; hx = 0.1;
fsxf = 1;
fsyf = 1;
fszf = 1;
fscf = 1.0;
rotation=0;
figscale=0.5;
fstick = 8;
fslabel = 10;
misc.assigndefaults(varargin{:});
fsyf
aurea=1.61803398875;
%ax = get(fig, 'Children');
set(fig, 'Resize', 'off');
ax = findobj(fig, 'Type', 'Axes');
cax = findobj(fig, 'Tag', 'Colorbar');
if length(ax) > 1
   display('--')
   display(' --')
   display('  --')
   display('   --')
   display('    --')
   display(' Figure not handled by this script, more than one axes in the figure')
   return
end


xl = get(ax, 'XLim');
yl = get(ax, 'YLim');
x0 = xl(1); xf = xl(2);
y0 = yl(1); yf = yl(2);

% if neither prxr or pryr is set, set defaults
if prxr == -1 & pryr == -1
   prxr = 2.4;
   if axequal
      if axtransposed
         pryr = prxr/(yf-y0)*(xf-x0);
      else
         pryr = prxr/(xf-x0)*(yf-y0);
      end
   else
      pryr = prxr/aurea;
   end
elseif prxr ~= -1 & pryr ~= -1
   % basically do nothing
   dummydummy=1; 
elseif prxr ~= -1 
   if axequal
      if axtransposed
         pryr = prxr/(yf-y0)*(xf-x0);
      else
         pryr = prxr/(xf-x0)*(yf-y0);
      end
   else
      pryr = prxr/aurea;
   end
elseif pryr ~= -1
   if axequal
      if axtransposed
         prxr = pryr/(xf-x0)*(yf-y0);
      else
         prxr = pryr/(yf-y0)*(xf-x0);
      end
   else
      prxr = pryr*aurea;
   end
end



% sizes are defined. Enlarge with scale
prxr = prxr/figscale;
pryr = pryr/figscale;
wa = wa/figscale;
wx = wx/figscale;
ha = ha/figscale;
hx = hx/figscale;
fstick  = fstick/figscale; % Tick Font Size
fslabel = fslabel/figscale; % Label Font Size


vv = version('-release');
vv = str2num(vv(1:4));
if vv < 2014
   fntick = 'Times';
   fnlabel = 'Times';
else
   fntick = 'CMU Serif';
   fnlabel = 'Te X Gyre Schola';
   set(ax, 'TickLabelInterpreter', 'Latex');
end
set(ax, 'FontName', fntick);
set(ax, 'FontSize', fstick);

% check colorbar
if ~isempty(cax)
   set(cax, 'TickLabelInterpreter', 'Latex');
   set(cax, 'FontName', fntick);
   set(cax, 'FontSize', fscf*fstick);
end

xlab = get(ax, 'XLabel');
set(xlab, 'FontName', fnlabel);
set(xlab, 'FontSize', fsxf*fslabel);

ylab = get(ax, 'YLabel');
set(ylab, 'FontName', fnlabel);
set(ylab, 'FontSize', fsyf*fslabel);

zlab = get(ax, 'ZLabel');
set(zlab, 'FontName', fnlabel);
set(zlab, 'FontSize', fszf*fslabel);
if vv >= 2014
   set(xlab, 'Interpreter', 'Latex');
   set(ylab, 'Interpreter', 'Latex');
   set(zlab, 'Interpreter', 'Latex');
end

if rotation == 0
   if axtransposed
      set(xlab,'Rotation', rotation,'HorizontalAlignment','right', ...
      'VerticalAlignment', 'middle') 
   else
      set(ylab,'Rotation', rotation,'HorizontalAlignment','right', ...
      'VerticalAlignment', 'middle') 
   end
else
   if axtransposed
      set(xlab,'Rotation', rotation)
   else
      set(ylab,'Rotation', rotation)
   end
end

% HAS BOTH AXES?
if ~xflag
   if axtransposed
      wa = wx;
   else
      ha = hx;
   end
   set(get(ax, 'XLabel'), 'String', '');
   set(ax, 'XTickLabel', []);
end
if ~yflag
   if axtransposed
      ha = hx;
   else
      wa = wx;
   end
   set(get(ax, 'YLabel'), 'String', '');
   set(ax, 'YTickLabel', []);
end
if ~zflag
   set(get(ax, 'ZLabel'), 'String', '');
   set(ax, 'ZTickLabel', []);
end

% FIGURE DIMENSIONS
wf = wa + prxr + wx;
hf = ha + pryr + hx;
set(fig, 'Units', 'inches');
set(ax , 'Units', 'inches');
set(fig, 'Position', [1.0 1.0 wf hf]);
set(ax , 'Position', [wa ha prxr pryr]);

% MOVE Y LABEL TO LEFT OF FIGURE
%set(ylab, 'Units', 'Inches');
%set(ylab, 'Position', [-wa pryr/2 0], 'HorizontalAlignment','left');

if nargout >= 1
   ss.wf = wf*figscale;
   ss.hf = hf*figscale;
   ss.prxr = prxr*figscale;
   ss.pryr = pryr*figscale;
   ss.ha = ha*figscale;
   ss.hx = hx*figscale;
   ss.wa = wa*figscale;
   ss.wx = wx*figscale;
   varargout{1} = ss;
end
if nargout == 2
   nl=sprintf('\n');
   mystr=[ ...
   ' +========================================+   ' nl ...
   ' |                          ^             |^  ' nl ...
   ' |                          hx            |:  ' nl ...
   ' |                          v             |:  ' nl ...
   ' |        +------------------------+      |:  ' nl ...
   ' |<__wa__>|                    ^   |      |:  ' nl ...
   ' |        |                    :   |<_wx_>|:  ' nl ...
   ' |        |                    :   |      |:  ' nl ...
   ' |        |                    pryr|      |:  ' nl ...
   ' |        |                    :   |      |hf  ' nl ...
   ' |        |                    :   |      |:  ' nl ...
   ' |        |<_________prxr______v__>|      |:  ' nl ...
   ' |        +------------------------+      |:  ' nl ...
   ' |                         ^              |:  ' nl ...
   ' |                         ha             |:  ' nl ...
   ' |                         v              |v  ' nl ...
   ' +========================================+  ' nl ...
   '  <_________________wf___________________>  '];
   
   varargout{2} = mystr;
return
end
