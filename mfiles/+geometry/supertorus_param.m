function [x,y,z]=supertorus_param(R,r,L,ee,nn,np);

a(1)=r;
a(2)=r;
a(3)=L/2;
a(4)=R/r;
n=np;
epsilon=[nn,ee];

etamax=pi;
etamin=-pi;
wmax=pi;
wmin=-pi;
deta=(etamax-etamin)/n;
dw=(wmax-wmin)/n;
k=0;
l=0;
for i=1:n+1
  eta(i)=etamin+(i-1)*deta;
  for j=1:n+1
    w(j)=wmin+(j-1)*dw;
    x(i,j)=a(1)*(a(4)+sign(cos(eta(i)))*abs(cos(eta(i)))^epsilon(1))*sign(cos(w(j)))*abs(cos(w(j)))^epsilon(2);
    y(i,j)=a(2)*(a(4)+sign(cos(eta(i)))*abs(cos(eta(i)))^epsilon(1))*sign(sin(w(j)))*abs(sin(w(j)))^epsilon(2);
    z(i,j)=a(3)*sign(sin(eta(i)))*abs(sin(eta(i)))^epsilon(1);

  end

end
%surf(x,y,z,'EdgeColor','none','FaceColor','white');
%view(2)
%axis equal
%camlight
return
end
