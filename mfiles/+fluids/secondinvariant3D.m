function Q = secondinvariant()
% @author O. FLores
% @date 03-07-2014 by O. Flores \n 
%       Created
% @date 13-12-2014 by M. Moriche \n 
%       Modified. Q at interior p points. periodicity handled
% @date 20-12-2014 by M. Moriche \n 
%       Moved to a separated function
%
% @brief Method for vortex visualization
%
% @details
%
% Method to compute the second invariant of the velocity
% gradient tensor (Q), used to visualize vortices in 
% complex and tubrulent flows
% 
% Only valid for uniform cartesian meshes.
% 
%   +--^--+--^--+--^--+--^--+--^--+
%   |     |     |     |     |     |
%   >  +  >  +  >  +  >  +  >  +  >
%   |     |     |     |     |     |   + interior p points, Q points
%   +--^--+--^--+--^--+--^--+--^--+   > ux
%   |     |     |     |     |     |   ^ uz
%   >  +  >  +  >  +  >  +  >  +  >
%   |     |     |     |     |     |
%   +--^--+--^--+--^--+--^--+--^--+
%   |     |     |     |     |     |
%   >  +  >  +  >  +  >  +  >  +  >
%   |     |     |     |     |     |
%   +--^--+--^--+--^--+--^--+--^--+
% 
% @code
% Q = secondinvariant(x
% fr.secondinvariant
% 
% isosurface(fr.yp,fr.xp,fr.zp,fr.Q,qref)
% @endcode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Q ux uy uz dx dy dz
global xux yux zux
global xuy yuy zuy
global xuz yuz zuz
global nx ny nz
global perx pery perz
perx = 0;
pery = 0;
perz = 0;
% nx,ny,nz number of cells 
Q = zeros(nx,ny,nz);
Q = (diff(ux(1:end-perx,2:end-1,2:end-1),1,1)./dx).^2;
Q=Q+(diff(uy(2:end-1,1:end-pery,2:end-1),1,2)./dy).^2;
Q=Q+(diff(uz(2:end-1,2:end-1,1:end-perz),1,3)./dz).^2;
Q = -0.5*Q;


% dvdx * dudy: 
% v to xux,yux,zux
[xu,yu,zu] = ndgrid(xux(1:end-perx),yux,zux);
vv = interpn(xuy,yuy(1:end-pery),zuy,uy(:,1:end-pery,:),xu,yu,zu);  
clear xu yu zu
[xv,yv,zv] = ndgrid(xuy,yuy(1:end-pery),zuy);
% u to xuy,yuy,zuy
uu = interpn(xux(1:end-perx),yux,zux,ux(1:end-perx,:,:),xv,yv,zv);  
clear xv yv zv

Q = Q - diff(vv(:,2:end-1,2:end-1),1,1)./dx.*diff(uu(2:end-1,:,2:end-1),1,2)./dy;

%
%% dwdx * dudz: 
%% w to xux,yux,zux
[xu,yu,zu] = ndgrid(xux(1:end-perx),yux,zux);
ww = interpn(xuz,yuz,zuz(1:end-perz),uz(:,:,1:end-perz),xu,yu,zu);
clear xu yu zu
% u to xuz,yuz,zuz
[xw,yw,zw] = ndgrid(xuz,yuz,zuz(1:end-perz));
uu = interpn(xux(1:end-perx),yux,zux,ux(1:end-perx,:,:),xw,yw,zw);
clear xw yw zw

Q = Q - diff(ww(:,2:end-1,2:end-1),1,1)./dx.*diff(uu(2:end-1,2:end-1,:),1,3)./dz;

% dwdy * dvdz: 
% w to xuy,yuy,zuy
[xv,yv,zv] = ndgrid(xuy,yuy(1:end-pery),zuy);
ww = interpn(xuz,yuz,zuz(1:end-perz),uz(:,:,1:end-perz),xv,yv,zv);
clear xv yv zv
% v to xuz,yuz,zuz
[xw,yw,zw] = ndgrid(xuz,yuz,zuz(1:end-perz));
vv = interpn(xuy,yuy(1:end-pery),zuy,uy(:,1:end-pery,:),xw,yw,zw);  
clear xw yw zw

Q = Q - diff(ww(2:end-1,:,2:end-1),1,2)./dy.*diff(vv(2:end-1,2:end-1,:),1,3)./dz;

clear uu vv ww

return
end
