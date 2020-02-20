function [phix phiy] = ellipsesolution(xi, eta, e, AoA);

phix =   0.5*sqrt((1+e)/(1-e))*exp(-xi).*(sin(AoA)*sin(eta)+e*cos(AoA)*cos(eta));
phiy =   0.5*sqrt((1+e)/(1-e))*exp(-xi).*(cos(AoA)*sin(eta)-e*sin(AoA)*cos(eta));


return
end




