function [x,y] = e2c(a, b, e)

ff = 0.5*sqrt(1-e^2);
%ff = 0.5*(1-e^2);

gamma = a + i*b;

%z = 0.5*(1-e^2)*cosh(gamma);
z = ff*cosh(gamma);

x = real(z); y = imag(z);

return
end
