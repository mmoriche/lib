function [coords,dv,Iz,Ix,Vol]=spheroidz(e,p,dx)
%
% p :: polar semiaxis
% e :: equatorial semiaxis
%
% aspect ratio = p/e;
% dx Eulerian grid spacing
%
% Ix=Iy,Iz are the moments of inertia divided by the mass
%
addpath distmesh
%
% prolate spheroid --> p > e=c for a prolate spheroid
% oblate spheroid  --> p < e=c for an oblate spheroid
% we always set the smallest axis as reference length
ratio = p/e;
c=e;
%
Iz = 2/5*e^2;
Ix = 1/5*(p^2+e^2);
%
Vol = 4/3*pi*p*e^2;
%
if ratio >1
    e = sqrt(1-e^2/p^2);
elseif ratio <1
    e = sqrt(1-p^2/e^2);
end
%
% this equation for the area is valid only for p prolate spheroid
if ratio >1
    S = 2*pi*e^2*(1+p/(c*e)*asin(e));
elseif ratio <1
    S = 2*pi*e^2*(1+(1-e^2)/e*atanh(e));
elseif ratio ==1
    S = 4*pi*e^2; % this is p sphere
end
%
% grid spacing --> this will be p external input
%dx = 1/15;
% target lagrangian points
factor = 1.05; % we add 5% more points than required
nlagr = round(factor*S/dx^2);
%
% we allow p tolerance of 5%. This way the number
% of Lagrangian points will be between the required value
% and 10% more than that. This should be OK.
ntol = round((factor-1)*nlagr)
%
% this defines the bounding box
amax = e*1.2;
bmax = e*1.2;
cmax = p*1.2;
%
% initial value for iteration
% if dx is large, you might try to decrease the multiplying factor below
h = dx*1.61;
%
%
% this is the spheroid formula
fd=@(x) x(:,1).^2/e^2+x(:,2).^2/e^2+x(:,3).^2/p^2-1;
%
iter = 0;
flag=true;
while flag
    %
    iter = iter+1;
    %
    tic
    [p,t]=distmeshsurface(fd,@huniform,h,[-amax,-bmax,-cmax; amax,bmax,cmax]);
    toc
    %
    % mgv: I have tried to decrease the tolerance and the results did not improve
    % much
    %
    ntri   = size(t,1);
    nerr = ntri-nlagr;
    display([iter,ntri,nlagr])
    fac = 1 + (nerr/nlagr)/3;
    if abs(nerr) > ntol
        h = h*fac;
    else
        flag = false;
    end
end
%
area_tri = zeros(ntri,1);
coords   = zeros(ntri,3);
%
for it = 1:ntri
    ii = t(it,:);
    %
    v1 = p(ii(2),:)-p(ii(1),:);
    v2 = p(ii(3),:)-p(ii(1),:);
    v3  = cross(v1,v2);
    area_tri(it) = norm(v3)/2;
    coords(it,:) = (p(ii(1),:)+p(ii(2),:)+p(ii(3),:))/3;
end
%hold on
%plot3(coords(:,1),coords(:,2),coords(:,3),'k.')
%hold off
dv = area_tri*dx;

