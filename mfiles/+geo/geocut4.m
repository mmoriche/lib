function [latAB, lonAB, ii1, ii2] = geocut4(latOA_line, lonOA_line, latOB_line, lonOB_line, ss);

sOA = linspace(0,1,length(latOA_line));
sOB = linspace(0,1,length(latOB_line));
llref = [latOA_line(1) lonOA_line(1)];
llref = [0 lonOA_line(1)];

lonOA_line = mod(lonOA_line - (llref(2)-180),360)-180;
lonOB_line = mod(lonOB_line - (llref(2)-180),360)-180;

fOA = @(s1) interp1(sOA, [latOA_line lonOA_line], s1);
fOB = @(s2) interp1(sOB, [latOB_line lonOB_line], s2);

N = 6;
tol = 1e-8;
err = 2*tol;
s10 = 0;
s1f = 1;
s20 = 0;
s2f = 1;

while err > tol & (s1f-s10 > tol | s2f -s20 > tol)
   ssweep1 = linspace(s10,s1f,N);
   ssweep2 = linspace(s20,s2f,N);
   for i1 = 1:N
      for i2 = 1:N
         s1 = ssweep1(i1);
         s2 = ssweep2(i2);
         L(i1,i2) = geo.fobj2(s1,s2,latOA_line, lonOA_line, latOB_line, lonOB_line, llref, ss);
      end
   end
   err = min(L(:));
   [i1 i2] = find(L == min(L(:)));
   i1 = i1(1);
   i2 = i2(1);
   i10 = max(1,i1-1);
   i1f = min(i1+1,N);
   i20 = max(1,i2-1);
   i2f = min(i2+1,N);
   s10 = ssweep1(i10);
   s1f = ssweep1(i1f);
   s20 = ssweep2(i20);
   s2f = ssweep2(i2f);

end

lla = fOA(s1);
llb = fOB(s2);

latAB = 0.5*(lla(1)+llb(1));

% move to 360
lonAB = 0.5*(lla(2)+llb(2));
lonAB = mod(lonAB + llref(2)+180,360)-180;

ii1 = find(sOA<s1);
ii2 = find(sOB<s2);

return
end
