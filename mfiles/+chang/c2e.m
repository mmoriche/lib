function [xi,eta] = c2e(x, y, e, alfa)


beta = atan2(y,x);

x2 = sqrt( x.^2 + y.^2).*cos(beta+alfa);
y2 = sqrt( x.^2 + y.^2).*sin(beta+alfa);

z = (x2 + i*y2);

ff = 0.5*sqrt(1-e^2);

%gamma = acosh(z/(0.5*(1-e^2)));
gamma = acosh(z/ff);

xi = real(gamma); eta = imag(gamma);

return
end
