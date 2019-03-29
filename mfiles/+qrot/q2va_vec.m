function [v a] = q2va_vec(q)
%
%
%
% Assumes second dimension of q 4
%
%

qw=q(:,4);
qx=q(:,1);
qy=q(:,2);
qz=q(:,3);

nt=size(q,1);

v=zeros(nt,3);
a=zeros(nt,1);
a(:) = 2*acos(qw);
v(:,1)=qx./sqrt(1-qw.*qw);
v(:,2)=qy./sqrt(1-qw.*qw);
v(:,3)=qz./sqrt(1-qw.*qw);

return
end
