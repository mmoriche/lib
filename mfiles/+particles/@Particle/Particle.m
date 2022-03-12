classdef Particle  < handle
   properties (SetAccess=protected)
      x(3,1) double = [0;0;0];
      q(4,1) double = [0;0;0;1];
   end
   methods
      function self = Particle()
      end
      function self = set.x(self,x)
         assert(length(x)==3);
         self.x(:) = x(:);
         return
      end
      function self = set.q(self,q)
         assert(length(q)==4);
         z=norm(q);
         if z ~=  1
            if abs(1-z) < 0.01
               q=q/z;
            elseif abs(1-z) < 0.1
               warning(sprintf('Norm of quaternion is not unity (|q|=%f), rescaling',z));
               q=q/z;
            else 
               error(sprintf('Norm of quaternion is far from unity (|q|=%f)',z));
            end
         end
         self.q(:) = q(:);
         return
      end
      self = shift( self, v);
      self = rotate(self, v);
   end
end

