function quat = eu2q(ac)
% \details 
% 
%  yaw   = ac(1)
%  pitch = ac(2)
%  roll  = ac(3)
% 
% 

cy = cos(0.5*ac(1));
sy = sin(0.5*ac(1));
cp = cos(0.5*ac(2));
sp = sin(0.5*ac(2));
cr = cos(0.5*ac(3));
sr = sin(0.5*ac(3));

quat=zeros(4,1);

quat(4) =cy*cp*cr+sy*sp*sr;

quat(1) =cy*cp*sr-sy*sp*cr;
quat(2) =sy*cp*sr+cy*sp*cr;
quat(3) =sy*cp*cr-cy*sp*sr;

return
end 
