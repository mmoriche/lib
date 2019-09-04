function nn = getnormal(xx,A, B, C, F, G, H, P, Q, R)

nx = 2*A*xx(1) + 2*G*xx(3) + 2*H*xx(2) + 2*P;
ny = 2*B*xx(2) + 2*H*xx(1) + 2*F*xx(3) + 2*Q;
nz = 2*C*xx(3) + 2*F*xx(2) + 2*G*xx(1) + 2*R;

nn = zeros(3,1);
nn(:) = [nx ny nz];
nn = nn./norm(nn);

return
end
