function [dd_x,dd_y,dd_z]=bbox(esax,psax,quat)
%function [dd_x,dd_y,dd_z]=bbox(esax,psax,quat)
%
% @author M.Moriche
% @date 06-02-2019 by M.Moriche \n
%                  Created
% @brief Function to determine +- distances wrt center in bounding box
%
% INPUT
% esax: equatorial semiaxis
% psax: polar semiaxis
% quat: quaternions (q(1:3) vector, q(4) scalar)
%
%
% @example
%
% [ddx,ddy,ddz]=spheroids.bbox(a,c,quat);
% xmin = xc - ddx;
% xmax = xc + ddx;
% ...
ii = [1 0 0];
jj = [0 1 0];
kk = [0 0 1];

R= qrot.q2R(quat); Rt = R';

ii_b = R*ii';
dd_x = sqrt(ii_b(1)^2*esax^2 + ii_b(2)^2*esax^2 + ii_b(3)^2*psax^2);
jj_b = R*jj';
dd_y = sqrt(jj_b(1)^2*esax^2 + jj_b(2)^2*esax^2 + jj_b(3)^2*psax^2);
kk_b = R*kk';
dd_z = sqrt(kk_b(1)^2*esax^2 + kk_b(2)^2*esax^2 + kk_b(3)^2*psax^2);

return
end
