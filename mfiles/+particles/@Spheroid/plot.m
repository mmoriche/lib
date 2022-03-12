function h=plot(self,ax, varargin)

default_nle=20;
default_nlw=20;
default_surfoptions={'FaceColor','b'};
p=inputParser;
addRequired(p,'ax',@(x) isa(x,'matlab.graphics.axis.Axes') && length(x)==1);
addOptional(p,'surfoptions',default_surfoptions);
addOptional(p,'nle',default_nle);%,@(x) isnumeric(x) && isscalar(x) && rem(x)==0 && x>=1);
addOptional(p,'nlw',default_nlw);%,@(x) isnumeric(x) && isscalar(x) && rem(x)==0 && x>=1);
parse(p,ax,varargin{:});
surfoptions=p.Results.surfoptions;
nle=p.Results.nle;
nlw=p.Results.nlw;

esax=self.sizeparams(1);
psax=self.sizeparams(2);
[X,Y,Z] = ellipsoid(self.x(1),self.x(2),self.x(3),esax,esax,psax,nle,nlw);
[v,a] = qrot.q2va(self.q);
h=surf(X,Y,Z,surfoptions{:});
rotate(h,v,a*180/pi,self.x);

return 
end
