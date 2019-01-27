classdef SNUFF2 < SUFF2
%
% \author A.Gonzalo
% \date 04-04-2018 by M.Moriche \n
%       Created from SNUFF3
%
% \brief Structured Non-Uniform Fluid Field
%
% \details
%
% Class to simplify the postprocessing of simulation frames.
% Scripts that use this class result much more clear
%
% METHODS:
%  - vorticity 
%  - getQ
%  - getgroups
%

%properties(Access = public)
properties

% Eulerian mesh
dxr;
dyr;

end  % properties
  
methods
function self = SNUFF2(varargin)
% @author A.Gonzalo
% \date 06-05-2016 by A.Gonzalo \n
%       Created from SUFF3
%
% @brief Structured Non-Uniform field Class
%
% @details
%
% MANDATORY ARGUMENTS:
%                                     
%
% OPTIONAL ARGUMENTS:
% - slab = NaN(ndim,2); Box to make an slab of the fields
% - doslab = true; flag to Slab the field
% - nps = 0; number of passive scalars fields solved
% 
% Members:
% 
% 
% examples:
%
% @code
% fr = SNUFF()
% fr = SNUFF('nps',1)
% @endcode


% SuperClass inheritance
self@SUFF2(varargin{:});

% Optionals arguments
misc.assigndefaults(varargin{:});

% generate items to read fields (dependent on ndim)
itemsByGroup      = self.getgroups(self.ndim);
self.itemsByGroup = itemsByGroup;

end

function disp(self)
    tab = {'Structured Non-Uniform Flow Field', ['Dim: ' num2str(self.ndim)]};
    if self.doslab
       row = {'Slabbed', mat2str(self.slab)};
       tab = [tab; row];
    end
    row = {'Groups', misc.strjoin(fields(self.itemsByGroup), ', ')};
    tab = [tab; row];
    mytab.tab2ascii(tab)
return
end

vorticity(self, idir)
   
end  % methods
end  % class

