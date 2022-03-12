function self = rotate(self,v)

p=inputParser;
addRequired(p,'v',@(x) isnumeric(x) && sum(size(x)==[3,3])==2 || length(x)==4);
parse(p,v);

if length(v) == 4
   q2 = v;
else
   q2 = qrot.q2R(v);
end

self.q(:)=qrot.quatrot(self.q,q2);

return
end
