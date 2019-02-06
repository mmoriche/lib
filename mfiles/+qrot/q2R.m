%  \author M.Garcia-Villalba
%  \date 19-05-2015 by M.Garcia-Villalba \n
%        Created
%  \date 19-05-2015 by M.Moriche, M.Garcia-Villalba \n
%        Adapted for TUCAN
%
%  \details
%  
%
%-- obtain the rotation matrix from a quaternion
%-- eq. (2.46) Tewari(2007) [Book]
%
%-- input quaternion
%
function R = q2R(q)

R = zeros(3,3);
S = R;

S(1,1) =  0.0;
S(1,2) = -q(3);
S(1,3) =  q(2);
S(2,1) =  q(3);
S(2,2) =  0.0;
S(2,3) = -q(1);
S(3,1) = -q(2);
S(3,2) =  q(1);
S(3,3) =  0.0;
  
temp = 0.0;
for j=1:3 
   for i=1:3
      R(i,j) = 2.0*(q(i)*q(j)-q(4)*S(i,j)); 
   end
   temp = temp - q(j)*q(j);
end
temp = temp + q(4)*q(4);

for i=1:3
    R(i,i) = R(i,i) + temp;
end

return
end
