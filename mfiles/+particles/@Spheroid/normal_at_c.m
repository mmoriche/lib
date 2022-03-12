function nn = normal_at_c(self,xx)

nx = 2*self.AFPD(1)*xx(1) + 2*self.AFPD(5)*xx(3) + 2*self.AFPD(6)*xx(2) + 2*self.AFPD(7);
ny = 2*self.AFPD(2)*xx(2) + 2*self.AFPD(6)*xx(1) + 2*self.AFPD(4)*xx(3) + 2*self.AFPD(8);
nz = 2*self.AFPD(3)*xx(3) + 2*self.AFPD(4)*xx(2) + 2*self.AFPD(5)*xx(1) + 2*self.AFPD(9);

nn = zeros(3,1);
nn(:) = [nx ny nz];
nn = nn./norm(nn);

return
end

