function updateax(ax,varargin)

% h: horizontal axis
% v: vertical   axis

seq='xy';
ax_lw=1;
fshf=1;
fsvf=1;
fslabel = 6;
fstick = 10;
figscale=0.5;
rotation=0;

misc.assigndefaults(varargin{:});


ax_lw=ax_lw/figscale;
fshf=fshf/figscale;
fsvf=fsvf/figscale;
fslabel=fslabel/figscale;
fstick=fstick/figscale;

set(ax, 'LineWidth', ax_lw);

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

hlab = get(ax, [seq(1) 'label']);
set(hlab, 'FontName', fnlabel);
set(hlab, 'FontSize', fshf*fslabel);

vlab = get(ax, [seq(2) 'label']);
set(vlab, 'FontName', fnlabel);
set(vlab, 'FontSize', fsvf*fslabel);

if vv >= 2014
   set(hlab, 'Interpreter', 'Latex');
   set(vlab, 'Interpreter', 'Latex');
end

if rotation==0
   set(vlab,'Rotation', rotation, ...
            'HorizontalAlignment','right', ...
            'VerticalAlignment', 'middle') 
end

return
end
