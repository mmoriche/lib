function q = a2q(a)

cy = cos(0.5*a(1));
sy = sin(0.5*a(1));
cp = cos(0.5*a(2));
sp = sin(0.5*a(2));
cr = cos(0.5*a(3));
sr = sin(0.5*a(3));

q(1) =sr*cp*cy+cr*sp*sy;
q(2) =cr*sp*cy-sr*cp*sy;
q(3) =cr*cp*sy+sr*sp*cy;

q(4) =cr*cp*cy-sr*sp*sy;


return
end
