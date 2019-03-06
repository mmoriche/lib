function [m n] = findmn(q,varargin)
% @brief Function to find the closest integer to q, such that q \approx 2^m*3^n
% @author M.Moriche
% @date 05-06-2014 by M.Moriche \n
%       Created
%
%
m0 = 0;
n0 = 0;
mend = Inf;
nend = Inf;
misc.assigndefaults(varargin{:});

n = 0;
mendtrial = ceil((log(q) - n*log(3))/log(2));
mend = min(mendtrial, mend);
m = 0;
nendtrial = ceil((log(q) - m*log(2))/log(3));
nend = min(nendtrial, nend);

mrange = m0:mend;
nrange = n0:nend;

[M N] = ndgrid(mrange,nrange);

U = 2.^M.*3.^N;
[i j] = find(abs(U-q) == min(abs(U(:)-q)));
m = mrange(i);
n = nrange(j);

return
end
