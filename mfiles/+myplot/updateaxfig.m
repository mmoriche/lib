function updateaxfig(fig,ax,varargin)
%function updateaxfig(fig,ax,varargin)
%
%figscale=0.5;
%ha=0.4; hx=0.1;
%va=0.4; vx=0.1;
%axequal=false;
%prhr=-1;
%prvr=-1;
%seq='xy';
%hflag=true;
%vflag=true;
%misc.assigndefaults(varargin{:});

figscale=0.5;
ha=0.5; hx=0.2;
va=0.4; vx=0.2;
axequal=false;
prhr=-1;
prvr=-1;
seq='xy';
hflag=true;
vflag=true;
misc.assigndefaults(varargin{:});

seqref='xyz';

set(fig, 'Resize', 'off');
aurea=1.61803398875;

hl = get(ax, [seq(1) 'lim']);
vl = get(ax, [seq(2) 'lim']);

hr=diff(hl);
vr=diff(vl);

% if neither prhr or prvr is set, set defaults
if prhr == -1 & prvr == -1
   prhr = 2.4;
end

if prhr == -1 ||  prvr == -1
   if prhr ~= -1 
      if axequal
         prvr = prhr/hr*vr;
      else
         prvr = prhr/aurea;
      end
   elseif prvr ~= -1
      if axequal
         prhr = prvr/vr*hr;
      else
         prhr = prvr*aurea;
      end
   end
end

% sizes are defined. Enlarge with scale
prhr = prhr/figscale;
prvr = prvr/figscale;
ha = ha/figscale;
hx = hx/figscale;
va = va/figscale;
vx = vx/figscale;

if ~hflag, ha=hx; end
if ~vflag, va=vx; end

% FIGURE DIMENSIONS
wf = ha + prhr + hx;
hf = va + prvr + vx;
set(fig, 'Units', 'inches');
set(ax , 'Units', 'inches');
set(fig, 'Position', [1.0 1.0 wf hf]);
set(ax , 'Position', [ha va prhr prvr]);

return
end
