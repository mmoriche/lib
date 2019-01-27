function [lat lon azi] = getmidperp(xyz1, xyz2, ss)

x1 = xyz1(1); y1 = xyz1(2); z1 = xyz1(3);
x2 = xyz2(1); y2 = xyz2(2); z2 = xyz2(3);
[lat1, lon1, h1] = geocent_inv(x1,y1,z1,ss);
[lat2, lon2, h2] = geocent_inv(x2,y2,z2,ss);

[L,azi1,azi2] = geoddistance(lat1,lon1,lat2,lon2,ss);

[lat, lon, azi] = geodreckon(lat1, lon1, 0.5*L, azi1, ss);

return
end
