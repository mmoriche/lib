function q = R2q(R)
%>  \author M.Garcia-Villalba
%!  \date 19-05-2015 by M.Garcia-Villalba \n
%!        Created
%!  \date 20-05-2015 by M.Moriche, M.Garcia-Villalba \n
%!        Adapted for TUCAN
%!  \date 26-09-2018 by M.Moriche\n
%!        Bug in counter for q(4)...
%!
%!  \details
%!  
%! !--mgv may 2015
%! !
%! !-- obtain quaternion from the rotation matrix 
%! !-- Tewari(2007) [Book]
%! !
%! !-- input quaternion
%!
%subroutine R2q(R,q)
%implicit none
%integer, parameter:: realprec=8
%real(realprec), dimension(4)    :: q
%real(realprec), dimension(3,3)  :: R
%real(realprec)                  :: temp,trace,maxq
%integer                 :: i,j,indi(1)
%-----
trace = R(1,1)+R(2,2)+R(3,3);
      
for i=1:3
 q(i) = (1.0+2.0*R(i,i)-trace)/4.0;
end
q(4) = (1.0+trace)/4.0;
%      maxq = maxval(q)
%indi = maxloc(q);
indi = find(q==max(q));
maxq = q(indi(1));
%      write(*,*) maxq,q(indi)
if indi(1)==4 
  q(4) = sqrt(maxq);
  q(1) = (R(2,3)-R(3,2))/(4.0*q(4));
  q(2) = (R(3,1)-R(1,3))/(4.0*q(4));
  q(3) = (R(1,2)-R(2,1))/(4.0*q(4));
elseif indi(1)==3
  q(3) = sqrt(maxq);
  q(1) = (R(1,3)+R(3,1))/(4.0*q(3));
  q(2) = (R(3,2)+R(2,3))/(4.0*q(3));
  q(4) = (R(1,2)-R(2,1))/(4.0*q(3));
elseif indi(1)==2
  q(2) = sqrt(maxq);
  q(1) = (R(1,2)+R(2,1))/(4.0*q(2));
  q(3) = (R(3,2)+R(2,3))/(4.0*q(2));
  q(4) = (R(3,1)-R(1,3))/(4.0*q(2));
elseif indi(1)==1
  q(1) = sqrt(maxq);
  q(2) = (R(1,2)+R(2,1))/(4.0*q(1));
  q(3) = (R(1,3)+R(3,1))/(4.0*q(1));
  q(4) = (R(2,3)-R(3,2))/(4.0*q(1));
end

return
end

