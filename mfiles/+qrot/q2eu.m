function a = q2eu(q)
% !! \details 
% !! 
% !! 
% !!  yaw   = a(1)
% !!  pitch = a(2)
% !!  roll  = a(3)
% !! 
% !! 
% subroutine q2a(q,a)
% implicit none
% integer, parameter:: realprec=8
% real(realprec), dimension(3)  :: a
% real(realprec), dimension(4)  :: q

% real(realprec) num,den


% roll
num = 2d0*(q(4)*q(1)+ q(2)*q(3));
den = 1d0 - 2d0*(q(1)^2d0 + q(2)^2d0);
a(3) = atan2(num,den);

% pitch
num = 2d0*(q(4)*q(2)-q(3)*q(1));
a(2) = asin(num);

% yaw
num = 2d0*(q(4)*q(3)+ q(1)*q(2));
den = 1d0 - 2d0*(q(2)^2d0 + q(3)^2d0);
a(1) = atan2(num,den);

return
end

