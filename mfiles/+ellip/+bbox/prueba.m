%close all
clear all
close all


icase = 2

e = 1;
p = 0.15;
nstep=100;
% coordinates in body axis of spheroid
[xb0 yb0 zb0] = ellipsoid(0, 0, 0, e, e, p, 150, 150);
% initialize transformed coordinates
xx=reshape(xb0,size(xb0(:)));
yy=reshape(yb0,size(yb0(:)));
zz=reshape(zb0,size(zb0(:)));
dt = delaunayTriangulation(xx(:), yy(:), zz(:));
xy0 = dt.Points;
xy2 = xy0;
fac = dt.freeBoundary;

c1 = [194,255,1]/255;
c2 = [0,255,65]/255;
c3 = [7,170,103]/255;
c4 = [29,124,128]/255;

hold off
im(1) = patch('Faces', fac, 'Vertices', xy0, 'FaceColor',c1, 'EdgeColor','none','DiffuseStrength',1.0);
hold on
im(2) = patch('Faces', fac, 'Vertices', xy0, 'FaceColor',c2, 'EdgeColor','none','DiffuseStrength',1.0);



xlabel('x/b'); ylabel('y/b'); zlabel('z/b');

quat = zeros(4,1);
xc   = zeros(3,1);

xc0 = [0 0 0];
quat0 = qrot.va2q([1 1 1],0);
R0 = qrot.q2R(quat0);


vv = [1 1 1]; phi = pi/4;
quat = qrot.va2q(vv,phi);

R= qrot.q2R(quat); Rt = R';
xc = [2;1;0];
for i2 = 1:size(xy0,1)
   xy = xy0(i2,:)';
   xy2(i2,:) = xc + Rt*xy;
end


xlim([-3 3])
ylim([-3 3])
zlim([-3 3])
set(im(2), 'Vertices', xy2);

xl = get(gca, 'XLim');
yl = get(gca, 'YLim');
zl = get(gca, 'ZLim');

xv_1 = [0 1 1 0];
xv_2 = [1 0 0 1];
xi_1 = xl(1);
xi_2 = xl(2);
xx = xv_1.*xi_1 + xv_2.*xi_2;

yv_1 = [1 1 0 0];
yv_2 = [0 0 1 1];
yi_1 = yl(1);
yi_2 = yl(2);
yy = yv_1.*yi_1 + yv_2.*yi_2;

kplane = zeros(4,3);
kplane(:,1) = xx;
kplane(:,2) = yy;
jplane = zeros(4,3);
jplane(:,1) = xx;
jplane(:,3) = yy;
iplane = zeros(4,3);
iplane(:,2) = xx;
iplane(:,3) = yy;


if icase ~= 3
   kplane(:,3) = p
   ppk(1) = patch('Faces', 1:4, 'Vertices', kplane);
   kplane(:,3) = -p
   ppk(2) = patch('Faces', 1:4, 'Vertices', kplane);
end
if icase ~= 2
   
   jplane(:,2) = e
   ppj(1) = patch('Faces', 1:4, 'Vertices', jplane);
   jplane(:,2) = -e
   ppj(2) = patch('Faces', 1:4, 'Vertices', jplane);
end 

if icase ~= 1
   iplane(:,1) = e
   ppi(1) = patch('Faces', 1:4, 'Vertices', iplane,'EdgeColor','r');
   iplane(:,1) = -e
   ppi(2) = patch('Faces', 1:4, 'Vertices', iplane,'EdgeColor','b');
end

alpha(0.1)


if icase == 1
view(90,0);
elseif icase == 2
view(0,0);
elseif icase == 3
view(0,90);
end

camlight(90,5)

ii = [1 0 0];
jj = [0 1 0];
kk = [0 0 1];
%vv = [1 1 1]; 
vv = [1 1 0]; 

for i1 = 1:nstep

   xc(1) = 0 + 0.5*sin(0.1*i1+1);
   xc(2) = 1 + 0.2*sin(0.1*i1+3);
   xc(3) = 0 + sin(0.1*i1);

   vv(1) = 0 + 0.5*sin(0.1*i1+1);
   vv(2) = 1 + 0.2*sin(0.1*i1+3);
   vv(3) = 0 + sin(0.1*i1);
   

   %phi = i1*pi/16+pi/8*cos(0.2*i1);
   phi = i1*pi/16;

   quat = qrot.va2q(vv,phi);
   R= qrot.q2R(quat); Rt = R';

   for i2 = 1:size(xy0,1)
      xy = xy0(i2,:)';
      xy2(i2,:) = xc + Rt*xy;
   end
   set(im(2), 'Vertices', xy2);

   if icase ~= 3
      % plane k-normal
      kk_b = R*kk';
      dd_b = sqrt(kk_b(1)^2*e^2 + kk_b(2)^2*e^2 + kk_b(3)^2*p^2);
      
      zi = xc(3) + dd_b;
      kplane(:,3) = zi;
      set(ppk(1), 'Vertices', kplane);

      zi = xc(3) - dd_b;
      kplane(:,3) = zi;
      set(ppk(2), 'Vertices', kplane);
   end

   if icase ~= 2
      % plane j-normal
      jj_b = R*jj';
      dd_b = sqrt(jj_b(1)^2*e^2 + jj_b(2)^2*e^2 + jj_b(3)^2*p^2);
      
      yi = xc(2) + dd_b;
      jplane(:,2) = yi;
      set(ppj(1), 'Vertices', jplane);

      yi = xc(2) - dd_b;
      jplane(:,2) = yi;
      set(ppj(2), 'Vertices', jplane);
   end

   % plane i-normal
   if icase ~= 1
      ii_b = R*ii';
      dd_b = sqrt(ii_b(1)^2*e^2 + ii_b(2)^2*e^2 + ii_b(3)^2*p^2);
      
      xi = xc(1) + dd_b;
      iplane(:,1) = xi;
      set(ppi(1), 'Vertices', iplane);

      xi = xc(1) - dd_b;
      iplane(:,1) = xi;
      set(ppi(2), 'Vertices', iplane);
   end
   pause(0.05)
   drawnow

end
