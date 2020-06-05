function qpp=quatrot(q,qp)
% Program for combining two successive rotations, given by quaternions
% ’q’ and ’qp’, to produce the final orientation given by the quaternion
% ’qpp’. All the quaternions are stored here as COLUMN vectors.
% The order of rotations is defined from Earth to body-fixed
% Modified from 2006 Ashish Tewari
%original. Assumes row vectors% qpp=q'*[qp(4) qp(3) -qp(2) qp(1);
%original. Assumes row vectors% -qp(3) qp(4) qp(1) qp(2);
%original. Assumes row vectors% qp(2) -qp(1) qp(4) qp(3);
%original. Assumes row vectors% -qp(1) -qp(2) -qp(3) qp(4)]'

qpp=[qp(4) qp(3) -qp(2) qp(1);
-qp(3) qp(4) qp(1) qp(2);
qp(2) -qp(1) qp(4) qp(3);
-qp(1) -qp(2) -qp(3) qp(4)]*q;

end
