function [latOA_line lonOA_line] = projectperp2(latOA, lonOA, aziOA,  ...
  latO, lonO, latA, lonA, ss, L, turn)

N = 8;
ds = L/N;

azipre = aziOA + turn; 
azipre = mod(azipre+180,360)-180; 

LOcheck = [];
LAcheck = [];
tol = 1e-8;

latOA_line = zeros(N,1);
lonOA_line = zeros(N,1);
latOA_line(1) = latOA;
lonOA_line(1) = lonOA;

i0 = 1;

Lcheck=0;
rlx = 0.0;
while Lcheck < L

   i0 = i0 + 1;
   azi_S = azipre + 5*sign(turn);
   azi_R = azipre - 5*sign(turn);
   
   azi = 0.5*(azi_S + azi_R);
   azi = mod(azi+180,360)-180; 
   % guesses
   [lat, lon, dummy] = geodreckon(latOA_line(i0-1), lonOA_line(i0-1), ds, azi, ss);
   
   % check lengths
   [LA,azidummy,azidummy] = geoddistance(latO,lonO,lat,lon,ss);
   [LO,azidummy,azidummy] = geoddistance(latA,lonA,lat,lon,ss);
    %disp(sprintf('C %8d %12.2f %12.2f %12.2f %12.0f %12.0f %12.0f %12.4E %12.4E %12.4E %12.4E ', i0, lat, dummy, lon, azi_S, azi, azi_R, LO, LA, LO-LA))
   
   err = 2*tol;
   dazi = 2*tol;
   
   while err > tol && dazi > tol
   
      azi = 0.5*(azi_S + azi_R);
      %disp(sprintf('C %8d %12.2f %12.2f %12.0f %12.0f %12.0f %12.4E %12.4E %12.4E %12.4E ', i0, lat, lon, azi_S, azi, azi_R, LO, LA, LO-LA))
      %pause
   
      % guesses
      [lat, lon, dummy] = geodreckon(latOA_line(i0-1), lonOA_line(i0-1), ds, azi, ss);
      
      % check lengths
      [LO,azidummy,azidummy] = geoddistance(latO,lonO,lat,lon,ss);
      [LA,azidummy,azidummy] = geoddistance(latA,lonA,lat,lon,ss);
      
      if LO > LA
         azi_S = (1-rlx)*azi+rlx*azi_S;
      elseif LA > LO
         azi_R = (1-rlx)*azi+rlx*azi_R;
      else
         break
      end
   
      err = abs(LO-LA);
      dazi = abs(azi_S - azi_R);
   end

   latOA_line(i0) = lat;
   lonOA_line(i0) = lon;

   azipre = dummy;
   % ------------------------------
   [Lcheck,azidummy,azidummy] = geoddistance(latOA,lonOA,lat,lon,ss);

   if (i0 > 10*N)
      latOA_line = latOA_line(1:i0);
      lonOA_line = lonOA_line(1:i0);
      disp('path not found!!!!!')
      return
   end
end

latOA_line = latOA_line(1:i0);
lonOA_line = lonOA_line(1:i0);

return
end
