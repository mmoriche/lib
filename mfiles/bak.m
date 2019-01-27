function [fr, failitems] = readh5file(fnm, items)
% @author M.Moriche
% @date Created 06-06-13 by M.Moriche
% @date Modified 07-06-13 by M.Moriche
% @date 07-06-13 by M.Moriche
%       added extra arguments in H5D.read
% @date 22-07-13 by M.Moriche
%       added error handling and failitems as output
% @date 13-12-13 by M.Moriche
%       Organized and documented for trunk
% 
% @brief Function to read data from a file saved with HDF5 lib
%
% @details
%
% Uses low level function in HDF5 library. High level libraries are
%  not available in all Matlab releases.
%
% Mandatory arguments
%  - fnm: HDF5 file to be read.
%  - items: Datasets of the file to be read.
%
% No optional arguments.
%
% Examples:
%
%  @code
%  fr = readh5file('/data/nacamoving_102.0000.h5frame',{'ux','uy','xux'})
%  @endcode

failitems = {};

h5fid = H5F.open(fnm,'H5F_ACC_RDONLY','H5P_DEFAULT');

fr = struct;

for i = 1:length(items)
   try
      did = H5D.open(h5fid,items{i});
      fr.(items{i}) = H5D.read(did,...
       'H5ML_DEFAULT','H5S_ALL','H5S_ALL','H5P_DEFAULT');
      H5D.close(did);
      if strcmp(class(fr.(items{i})),'char')
         fr.(items{i}) = deblank(fr.(items{i}));
      end
   catch
      failitems = [failitems items{i}];
   end
end
H5F.close(h5fid);
end
