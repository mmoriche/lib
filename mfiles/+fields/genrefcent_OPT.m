function [cux cuy cuz cp n indxrb] = genrefcent_OPT(dom0,domf,domr0,domrf,k0,kf,...
                                                    ratio0,ratiof,dr,dir,varargin)
% @author A.Gonzalo
% 
% @brief function to build a mesh with:
%        coarse|stretching|refinement|stretching|coarse sections
% 
% @date  25-01-2015 by A.Gonzalo
%        Created
% @date  26-01-2015 by A.Gonzalo\n
%        Documented
% @date  09-04-2015 by A.Gonzalo\n
%        Added indxrb
% 
% @details
%
% @verbatim
% + Example of the mesh in y direction:
%
%  ------------------------------------------------------------ yf
%                      COARSE SECTION (dyc)
%  ------------------------------------------------------------
%            FINAL STRETCHING SECTION (dyr*(1+kyf)^i)
%  ------------------------------------------------------------ yrf
%                   FINAL REFINED SECTION (dyr)
%  ------------------------------------------------------------ yr0
%           INITIAL STRETCHING SECTION (dyr*(1+ky0)^i)
%  ------------------------------------------------------------
%                      COARSE SECTION (dyc)
%  ------------------------------------------------------------ y0
% @endverbatim
%
%  MANDATORY ARGUMENTS:
%  --------------------
%
%  - dom0: intial point of physical domain
%  - domf: final point of physical domain
%
%  - domr0: intial physical point of refined section
%  - domrf: final physical point of refined section
%
%  - k0: stretching factor of initial stretching section
%  - kf: stretching factor of final stretching section
%
%  - ratio0: refinement ratio of initial coarse section
%  - ratiof: refinement ratio of final coarse section
%
%  - dr: distance between points in refined section
%
%  - dir: direction you want to mesh:
%         x --> 1
%         y --> 2
%         z --> 3
%
%  OUTPUT ARGUMENTS:
%  -----------------
%
%  - cux: points of ux
%  - cuy: points of uy
%  - cuz: points of uz
%  - cp: points of p
%  - indxrb: beggining of refined zone index
%
% @code
% dir = 1;
% [xux2 xuy2 zuz2 xp2 nx irefbeg] = genrefcent(dom0,domf,domr0,domrf,k0,kf,...
%                                              ratio0,ratiof,dr,dir);
% dir = 2;
% [yux2 yuy2 yuz2 yp2 ny jrefbeg] = genrefcent(dom0,domf,domr0,domrf,k0,kf,...
%                                              ratio0,ratiof,dr,dir,...
%                                              'ghost',true);
% dir = 3;
% [zux2 zuy2 zuz2 zp2 nz krefbeg] = genrefcent(dom0,domf,domr0,domrf,k0,kf,...
%                                              ratio0,ratiof,dr,dir,...
%                                              'ghost',true,'per',perz);
% @endcode

per = 0;
ghost = false;
bcfix = false;
misc.assigndefaults(varargin{:});

[cux cuy cuz cp n indxrb] = fields.genrefcent(dom0,domf,domr0,domrf,k0,kf,...
                                      ratio0,ratiof,dr,dir,'per',per,'ghost',ghost,...
                                      'bcfix',bcfix);

if dir == 1
  cu = cux;
elseif dir == 2
  cu = cux;
elseif dir == 3
  cu = cux;
end
iibr = find(min(abs(cu - domr0)) == abs(cu-domr0));
cu(iibr);

cu2 = cu;
iilist = (iibr-1):-1:1;
for i1 = 1:length(iilist(1:end))
   ii = iilist(i1)
   cu2(ii) = cu2(ii+1).*(2+k0) - cu2(ii+2);
end
cu2(1)
cu(1)

return
end
