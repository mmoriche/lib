function vorticity(self,dim)
% @author M.Moriche
% @date Modified 25-05-2013 by M.Moriche
% @date Modified 06-05-2016 by A.Gonzalo
% @brief  Calculates vorticity
%    
% @details
%
%
% Calculates vorticity at xux, yuy points.
% Is saved in the property "w"
%
% @verbatim
%
% o  -  o  -  o  -  o  -  o  -  o      o  pressure points
%                                      - ux points
% |  *  |  *  |  *  |  *  |  *  |      | uy points
%                                
% o  -  o  -  o  -  o  -  o  -  o      
%                                      * vorticity points
% |  *  |  *  |  *  |  *  |  *  |
%                                
% o  -  o  -  o  -  o  -  o  -  o 
%                                
% |  *  |  *  |  *  |  *  |  *  |
%                                
% o  -  o  -  o  -  o  -  o  -  o 
%
% @endverbatim
%
%
% Usage example:
%   
% @code
% fr = SUFF(2);
% fr.vorticity(3);
% imagesc(fr.wz')
% @endcode
 
coords = {'x','y','z'};
%dimlist = 1:self.ndim
dimlist = 1:3;
dimstoread = setdiff(dimlist, dim);

nm = coords{dim};

dir1 = dimstoread(1);
dir2 = dimstoread(2);

nm1 = coords{dir1};
nm2 = coords{dir2};

fld1 = getfield(self, ['u' nm1]);
fld2 = getfield(self, ['u' nm2]);

c1 = getfield(self, [nm1 'u' nm2]);
c2 = getfield(self, [nm2 'u' nm1]);

dc1 = diff(c1);
dc2 = diff(c2);

i1 = size(diff(fld2,1,dir1));
i2 = size(diff(fld1,1,dir2));

if dim == 1
   h1ord = [2 1 3];
   h2ord = [2 3 1];
elseif dim == 2
   h1ord = [1 2 3];
   h2ord = [3 2 1];
elseif dim == 3
   h1ord = [1 3 2];
   h2ord = [3 1 2];
end

h1 = repmat(dc1,[1,i2(dim),i2(dir2)]); h1 = permute(h1,h1ord);
h2 = repmat(dc2,[1,i1(dim),i1(dir1)]); h2 = permute(h2,h2ord);

iend = min(i1(1),i2(1));
jend = min(i1(2),i2(2));
kend = min(i1(3),i2(3));

d1 = diff(fld2,1,dir1)./h1;
d2 = diff(fld1,1,dir2)./h2;


self.(['w' nm]) =  d1(1:iend, 1:jend, 1:kend) - d2(1:iend, 1:jend, 1:kend);

end
