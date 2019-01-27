function [ener] = getcoulomb(xyz, esax, psax);
%function [ener] = getcoulomb(xyz, esax, psax);

chi = esax/psax;
ee = sqrt(1-1/chi^2);
ss = [esax,ee];

N = size(xyz,1);

ener = 0;
for i1 = 1:N
   ii = (i1+1):N;
   x1 = xyz(i1,1); y1 = xyz(i1,2); z1 = xyz(i1,3);
   x2 = xyz(ii,1); y2 = xyz(ii,2); z2 = xyz(ii,3);
      
   [lat1, lon1, h1] = geocent_inv(x1,y1,z1,ss);
   [lat2, lon2, h2] = geocent_inv(x2,y2,z2,ss);
   
   [L,az1,az2] = geoddistance(lat1,lon1,lat2,lon2,ss);
   
   ener = ener + sum(1./L);

end

return
end
