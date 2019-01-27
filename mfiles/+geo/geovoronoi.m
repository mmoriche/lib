function [ da, xall_list, lall_list, xv_list, lv_list] = geovoronoi(xyz, esax, psax)

%gpath = getenv('GITHUB_PATH'); 
%addpath(fullfile(gpath, 'geographiclib-code/matlab/geographiclib'));
%
%
% Assumes z-orientation of the symmetry axis
%
% esax:: equatorial semi axis
% psax:: polar semiaxis
%
%
%
%
%
%
%
chi = esax/psax;
A = 1/esax^2;
B = 1/esax^2;
C = 1/psax^2;
D = -1;
ee = sqrt(1-1/chi^2);
% definition of the spheroid needed by geographiclib
ss = [esax,ee];



nib = size(xyz, 1);

geo.getfaces;

i0 = 0;

[dummy ipointlist] = sort(xyz(:,1));
for ipoint = ipointlist'

   tic
   i0 = i0 + 1;
   
   [ifaclist jdummy] = find(trifac == ipoint);
   
   % put the ipoint in the first position of the faces connectivity
   subtri = trifac(ifaclist,:);
   for i1 = 1:size(subtri,1)
      ii = find(subtri(i1,:) == ipoint);
      subtri(i1,:) = circshift(subtri(i1,:), 1-ii);
   end
   subtri2 = zeros(size(subtri));
   subtri2(1,:) = subtri(1,:);
   subtri = subtri(2:end,:);
   for i1 = 2:size(subtri,1)
      [i2 j2] = find(subtri(:,2) == subtri2(i1-1,3));
      subtri2(i1,:) = subtri(i2,:);
      iileft = setdiff(1:size(subtri,1), i2);
      subtri = subtri(iileft,:);
   end
   subtri2(end,:) = subtri;
   subtri = subtri2;
   
   dx = 1.5/24;
   L = 1.5*dx;
   
   lat_all = zeros(0,1);
   lon_all = zeros(0,1);
 
   xv = zeros(0,3);
   lv = zeros(0,2);
   
   for ifac = 1:size(subtri,1);

      iO = subtri(ifac,1);
      iA = subtri(ifac,2);
      iB = subtri(ifac,3);

      xyzO = xyz(iO,:);
      xyzA = xyz(iA,:);
      xyzB = xyz(iB,:);
   
      [latO lonO hO ] = geocent_inv(xyzO(1), xyzO(2), xyzO(3), ss);
      [latA lonA hA ] = geocent_inv(xyzA(1), xyzA(2), xyzA(3), ss);
      [latB lonB hB ] = geocent_inv(xyzB(1), xyzB(2), xyzB(3), ss);
      [latOA lonOA aziOA] = geo.getmidperp(xyzO, xyzA, ss);
      [latOB lonOB aziOB] = geo.getmidperp(xyzO, xyzB, ss);
      [latOA_line lonOA_line] = geo.projectperp2(latOA, lonOA, aziOA, ...
              latA, lonA, latO, lonO, ss, L,-90);
      [latOB_line lonOB_line] = geo.projectperp2(latOB, lonOB, aziOB, ...
              latB, lonB, latO, lonO, ss, L, 90);

      [latAB, lonAB, iiA, iiB] = geo.geocut4(latOA_line, lonOA_line, latOB_line, lonOB_line, ss);
      latOA_line = latOA_line(iiA(1:end));
      lonOA_line = lonOA_line(iiA(1:end));
      latOB_line = latOB_line(iiB(1:end));
      lonOB_line = lonOB_line(iiB(1:end));
   
      lat_all = cat(1, lat_all, latOA_line, latAB);
      lat_all = cat(1, lat_all, flipud(latOB_line));
      lon_all = cat(1, lon_all, lonOA_line, lonAB);
      lon_all = cat(1, lon_all, flipud(lonOB_line));
  
      [xAB, yAB, zAB] = geocent_fwd(latAB, lonAB, 0, ss);
      xv = cat(1, xv, [xAB yAB zAB]);
      lv = cat(1, lv, [latAB lonAB]);
   
   end
   
   [xall, yall, zall] = geocent_fwd(lat_all, lon_all, 0.00*esax, ss);
   
   da(ipoint)    = geodarea(lat_all, lon_all, ss);

   xall_list{ipoint} = [xall yall zall];
   lall_list{ipoint} = [lat_all lon_all];
   xv_list{ipoint} = xv;
   lv_list{ipoint} = lv;

   dfloat = toc;
   disp(sprintf('Point %d of %d done in %f seconds', i0, length(ipointlist), dfloat));

end

return
end
