function egeth5dset(fnm, varnm, varargin)
%%
%% @author M.Moriche                                                      %       
%% @brief Function to get dataset $varnm from a file saved with HDF5 lib  %
%% @date 13-03-2019 by M.Moriche \n                                       %
%%       Created from geth5dset                                           %
%%                                                                        %
%% @details                                                               %
%%                                                                        %
%% Uses low level function in HDF5 library. High level libraries are      %
%%  not available in all Matlab releases.                                 %
%%                                                                        %
%% Mandatory arguments                                                    %
%%  - fnm: HDF5 file name to be read.                                     %
%%  - varnm: Name of the variable to read                                 %
%%                                                                        %
%% Optional arguments.                                                    %
%%  - sizestruct =[]: struct to define the slicing of the dataset         %
%%            keys = {offset, stride, block, count}                       %
%%  - blank = true: boolean to indicate if character strings should be    %
%%                  deblanked.                                            %
%% Example:                                                               %
%%                                                                        %
%% @code                                                                  %
%% kz = io.geth5dset('/data2/mmoriche/myfile.h5', 'kz');                  %
%% siz.offset = [ 0  0];                                                  %
%% siz.stride = [ 1  1];                                                  %
%% siz.block  = [ 1  1];                                                  %
%% siz.count  = [32 32];                                                  %
%% ux=io.geth5dset('/data2/mmoriche/myfile.h5','ux','sizestruct', siz);   %
%% @endcode                                                               %
%%                                                                        %
%%                                                                        %
%%                                                                        %

sizestruct.offset = [];
sizestruct.stride = [];
sizestruct.block  = [];
sizestruct.count  = [];

blank     = true;
misc.assigndefaults(varargin{:});

failitems = {};

glist=who('global');
match=intersect(glist,{varnm});
if length(match) ~= 1
   error(sprintf('Variable %s must be defined as global',varnm));
end


str=sprintf('global %s',varnm);
eval(str);

h5fid = H5F.open(fnm,'H5F_ACC_RDONLY','H5P_DEFAULT');

did = H5D.open(h5fid,varnm);

if ~isempty(sizestruct.offset)
   offset = sizestruct.offset;
   stride = sizestruct.stride;
   block  = sizestruct.block;
   count  = sizestruct.count; 
   ndim = length(offset);
   sid  = H5D.get_space(did);
   H5S.select_hyperslab(sid, 'H5S_SELECT_SET', ...
                        fliplr(offset) , ...
                        fliplr(stride) , ...
                        fliplr(count)  , ...
                        fliplr(block)  );

   mid = H5S.create_simple(ndim, fliplr(count), []);

   %var = H5D.read(did,'H5ML_DEFAULT',mid, sid,'H5P_DEFAULT');
   str=sprintf(...
     '%s = H5D.read(did,''H5ML_DEFAULT'',mid, sid,''H5P_DEFAULT'');',...
     varnm);
   eval(str);
   H5S.close(sid);
   H5S.close(mid);
else
   sid = 'H5S_ALL';
   mid = 'H5S_ALL';
   %var = H5D.read(did,'H5ML_DEFAULT',mid, sid,'H5P_DEFAULT');
   str=sprintf(...
     '%s = H5D.read(did,''H5ML_DEFAULT'',mid, sid,''H5P_DEFAULT'');', ...
     varnm);
   eval(str);
end
H5D.close(did);

% remove blank spaces
str=sprintf('cl=class(%s);',varnm);
eval(str);
if strcmp(cl,'char') && blank
   str=sprintf('%s = deblank(%s)',varnm,varnm);
   eval(str);
end

H5F.close(h5fid);

return
end
