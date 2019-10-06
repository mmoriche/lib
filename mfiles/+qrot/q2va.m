function [v angle] = q2va(q)


qw=q(4);
qx=q(1);
qy=q(2);
qz=q(3);

v=zeros(3,1);
angle = 2*acos(qw);
v(1)=qx/sqrt(1-qw.*qw);
v(2)=qy/sqrt(1-qw.*qw);
v(3)=qz/sqrt(1-qw.*qw);

return
end
