function Q=ome2Qe(ome)
%
% returns the matrix needed to advance quaterions in time
%
Q=zeros(4,4);

Q(1,:) = [      0,-ome(3), ome(2), ome(1)];
Q(2,:) = [ ome(3),      0,-ome(1), ome(2)];
Q(3,:) = [-ome(2), ome(1),      0, ome(3)];
Q(4,:) = [-ome(1),-ome(2),-ome(3),      0];

return
end
