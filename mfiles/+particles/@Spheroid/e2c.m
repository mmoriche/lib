function xyz=e2c(self,ew)
% -pi/2 < ew(1) < pi/2
% -pi   < ew(2) < pi
p=inputParser;
addRequired(p,'ew',@(x) isnumeric(x) && length(x)==2 && abs(ew(1))<=pi/2 && abs(ew(2))<=pi);
parse(p,ew);

esax=self.sizeparams(1);
psax=self.sizeparams(2);
se=sin(ew(1));
ce=cos(ew(1));
sw=sin(ew(2));
cw=cos(ew(2));

xyz=zeros(3,1);
xyz(1) = esax*ce*cw;
xyz(2) = esax*ce*sw;
xyz(3) = psax*se;

return 
end
