classdef Spheroid < particles.Particle
   properties (Constant);
      nparams = 2;
   end
   properties(SetAccess=protected)
      sizeparams(2,1) double;
      AFPD(10,1) double;
      validAFPD logical=false;
   end
   methods
      function self = Spheroid(sizeparams)
         self.sizeparams=sizeparams;
      return
      end
      function self = set.sizeparams(self,sizeparams)
         if min(sizeparams)<=0.0
            error(sprintf('Size parameters must be strictly positive numbers (sizeparams=[%f,%f])',sizeparams))
         end
         self.sizeparams=sizeparams;
      return
      end
      function AFPD = get.AFPD(self)
         if ~self.validAFPD
            self.computecoeff();
         end
         AFPD=self.AFPD;
      return
      end
      function self = shift( self, v)
         self.validAFPD=false;
         v
         shift@particles.Particle(self,v);
         disp(self.x)
      return
      end
      function self = rotate(self, v)
         self.validAFPD=false;
         rotate@particles.Particle(self,v);
      return
      end
   end
   %% The following methods are declared in separate files
   methods
      % Coordinates transformations
      xyz=e2c(self,ew)
      computecoeff(self)
      n=normal_at_c(self,x)
      n=normal_at_e(self,e)
      % Plotting
      h=plot(self,varargin)
   end
end

