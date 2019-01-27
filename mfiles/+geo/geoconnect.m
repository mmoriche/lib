function [L udir1 udir2] = geoconnect(xyz1, xyz2, esax, psax);

A = 1/esax^2;
B = 1/esax^2;
C = 1/psax^2;
chi = esax/psax;
ee = sqrt(1-1/chi^2);
% definition of the spheroid needed by geographiclib
ss = [esax,ee];

x1 = xyz1(1); y1 = xyz1(2); z1 = xyz1(3);
x2 = xyz2(1); y2 = xyz2(2); z2 = xyz2(3);
[lat1, lon1, h1] = geocent_inv(x1,y1,z1,ss);
[lat2, lon2, h2] = geocent_inv(x2,y2,z2,ss);

[L,az1,az2] = geoddistance(lat1,lon1,lat2,lon2,ss)

un1 = [2*A*x1, 2*B*y1, 2*C*z1];
un2 = [2*A*x2, 2*B*y2, 2*C*z2];
un1 = un1/norm(un1);
un2 = un2/norm(un2);

vz = [0 0 1];
ulon1 = cross(vz, un1)  ; ulon1 = ulon1./norm(ulon1);
ulat1 = cross(un1,ulon1); ulat1 = ulat1./norm(ulat1);

ulon2 = cross(vz, un2)  ; ulon2 = ulon2./norm(ulon2);
ulat2 = cross(un2,ulon2); ulat2 = ulat2./norm(ulat2);

% direction of the repulsion force on 1
udir1 = -sind(az1)*ulon1 - cosd(az1)*ulat1;
udir2 = +sind(az2)*ulon2 + cosd(az2)*ulat2;

return
end
