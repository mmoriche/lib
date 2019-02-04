function cmap = linearcmap(values, colors, varargin)

nc = 64;
misc.assigndefaults(varargin{:});

vmin = min(values(:));
vmax = max(values(:));

vref = linspace(vmin, vmax,nc);
%nv = length(values);
%xx = linspace(1,nc,nv);
%vref = interpn(xx, values, 1:nc);

nstep = length(values);

cmap = zeros(nc,3);


iilist = zeros(nc,1);
ia_old = 0;
for i = 1:(nstep-1)
   v1 = values(i);
   v2 = values(i+1);
   rgb1 = colors(i  ,:);
   rgb2 = colors(i+1,:);
   ia = find(abs(vref(:)-v1) == min(abs(vref(:)-v1)));
   ib = find(abs(vref(:)-v2) == min(abs(vref(:)-v2)));
   nn = ib - ia + 1;

   %ia = max(ia_old + 1, ia);
   %ib = ia + nn - 1;

   r = linspace(rgb1(1),rgb2(1),nn);
   g = linspace(rgb1(2),rgb2(2),nn);
   b = linspace(rgb1(3),rgb2(3),nn);

   cmap(ia:ib,:) = [r' g' b'];

   ia_old = ia;
end

return
end
