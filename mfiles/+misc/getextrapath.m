function [relativepath isrel] = getextrapath( shortpath)
% function [relativepath isrel] = getextrapath( shortpath)
% @author M.Moriche 
% @date 29-10-2014
% @brief Function to relate to paths and give the relative one
%
% @details 
%
% OUTPUT: 
%  - relativepath: relaative path from short path to fullpath
%  - isrel: boolean indicating if short path is contained in fullpath
%
% MANDATORY ARGUMENTS: 
%  - fullpath: long path
%  - shortpath: long path
%
%
% @warning If isrel == false, the results is unpredictible
%
%
% @code
% objectspath = '/data2/mmoriche/myproject/notes/myfigures/example1';
% notespath   = '/data2/mmoriche/myproject/notes';
% [relativepath isrel] = relatepaths(objectspath, notespath);
% @endcode
%

aa=dbstack('-completenames');
caller_file=aa(2).file;
[callerpath,callerbase,callerext]=fileparts(caller_file);

[relativepath isrel] = misc.relatepaths(callerpath,shortpath);

return
end
