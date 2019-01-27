function L = fobj2(s1,s2,latOA_line, lonOA_line, latOB_line, lonOB_line, llref, ss)

sOA = linspace(0,1,length(latOA_line));
sOB = linspace(0,1,length(latOB_line));

% move longitudes to monotonic grow
fOA = @(s1) interp1(sOA, [latOA_line lonOA_line], s1);
fOB = @(s2) interp1(sOB, [latOB_line lonOB_line], s2);

lla = fOA(s1);
llb = fOB(s2);

lla(2) = mod(lla(2) + llref(2)+180,360)-180;
llb(2) = mod(llb(2) + llref(2)+180,360)-180;
L = geoddistance(lla(1),lla(2),llb(1),llb(2),ss);

return
end

