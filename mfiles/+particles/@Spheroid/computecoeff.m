% @author M.Moriche
% @date 17-05-2018
% @brief function to obtain coefficients of ellipsoid
%
% @details
%
% given a rotation matrix and the semi axis in the axial and radial
% directions (sa, sb), the coefficients for the algebraic expression
% that defines the ellipsoid are obtained
%
% The notation is taken from Lin 1995 (with capital letters)
%
% F(x,y,z)=A*x^2+B*y^2+C*z^2+2*F*yz+2*G*zx+2*H*xy+2*P*x+2*Q*y+2*R*z+D=0
%
function getcoeff(self)
%sa,sb,Rot,xc
xc=self.x;
sb=self.sizeparams(1);
sa=self.sizeparams(2);
Rot=qrot.q2R(self.q);

delta=zeros(3,3,3);
delta(1,1,1)=1;
delta(2,2,2)=1;
delta(3,3,3)=1;

xi = [1/(sb^2),1/(sb^2),1/(sa^2)];

% xx mono
A = 0;
B = 0;
C = 0;
% xy cross
F = 0;
G = 0;
H = 0;
% x
P = 0;
Q = 0;
R = 0;
% 1
D = -1;
for k=1:3
   for j=1:3
      for i=1:3
         A = A + xi(i)*delta(i,j,k)*Rot(j,1)*Rot(k,1);
         B = B + xi(i)*delta(i,j,k)*Rot(j,2)*Rot(k,2);
         C = C + xi(i)*delta(i,j,k)*Rot(j,3)*Rot(k,3);
         F = F + 0.5*(xi(i)*delta(i,j,k)*Rot(j,2)*Rot(k,3) ...
                     +xi(i)*delta(i,j,k)*Rot(j,3)*Rot(k,2));
         G = G + 0.5*(xi(i)*delta(i,j,k)*Rot(j,3)*Rot(k,1) ...
                     +xi(i)*delta(i,j,k)*Rot(j,1)*Rot(k,3));
         H = H + 0.5*(xi(i)*delta(i,j,k)*Rot(j,1)*Rot(k,2) ...
                     +xi(i)*delta(i,j,k)*Rot(j,2)*Rot(k,1));
         for r = 1:3
            P = P - 0.5*xi(i)*delta(i,j,k)*(Rot(j,r)*Rot(k,1) + Rot(j,1)*Rot(k,r))*xc(r);
            Q = Q - 0.5*xi(i)*delta(i,j,k)*(Rot(j,r)*Rot(k,2) + Rot(j,2)*Rot(k,r))*xc(r);
            R = R - 0.5*xi(i)*delta(i,j,k)*(Rot(j,r)*Rot(k,3) + Rot(j,3)*Rot(k,r))*xc(r);
            for s = 1:3
               D = D + xi(i)*delta(i,j,k)*Rot(j,r)*Rot(k,s)*xc(r)*xc(s);
            end
         end
      end
   end
end

self.AFPD=[A B C F G H P Q R D];
self.validAFPD=true;

return
end
