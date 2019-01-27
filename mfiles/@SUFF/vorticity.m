function vorticity(self,dim, varargin)
% @author M.Moriche
% @date Modified 25-05-2013 by M.Moriche
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

h1   = getfield(self, ['d' nm1]);
h2   = getfield(self, ['d' nm2]);

[i1,j1,k1] = size(diff(fld2,1,dir1));
[i2,j2,k2] = size(diff(fld1,1,dir2));

iend = min(i1,i2);
jend = min(j1,j2);
kend = min(k1,k2);

d1 = diff(fld2,1,dir1)/h1;
d2 = diff(fld1,1,dir2)/h2;


self.(['w' nm]) =  d1(1:iend, 1:jend, 1:kend) - d2(1:iend, 1:jend, 1:kend);

end
