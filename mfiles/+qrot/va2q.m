function q = va2q(v,a)

v2 = v./norm(v);

q = zeros(4,1);

q(1) = v2(1)*sin(a/2);
q(2) = v2(2)*sin(a/2);
q(3) = v2(3)*sin(a/2);
q(4) =       cos(a/2);

return
end
