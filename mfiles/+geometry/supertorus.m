function F = supertorus(x,y,z,R,r,L,ee,nn)
%function F = supertorus(x,y,z,R,r,L,ee,nn)
%
% Expression taken from 
%
% R is the radius of the torus R = 0.5*(Ro+Ri)
% r is the radius of the extruded section R = 0.5*(Ro-Ri)
% where Ro and Ri are the outer radius.
%
% L is the  total vertical length of the torus
%
a1=r;
a2=r;
a3=L/2;
alfa=R/r;

t1=(abs(x./a1)).^(2/ee);
t2=(abs(y./a2)).^(2/ee);
t3=(abs(  (t1+t2).^(ee/2) - alfa  )).^(2/nn);


F=t3+(abs(z./a3)).^(2/nn) - 1;
return
end
