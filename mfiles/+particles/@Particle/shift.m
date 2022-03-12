function self = shift(self,v)

p=inputParser;
addRequired(p,'v',@(x) isnumeric(x) && length(x)==3);
parse(p,v);

self.x(:)=self.x(:)+v(:);

return
end
