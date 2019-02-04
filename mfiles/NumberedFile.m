classdef NumberedFile < dynamicprops
%
% \brief Class to handle output files generated by the code IBcode
%
% \author M.Moriche
%
% \date 08-05-2014 by M.Moriche \n
%       Created
% \date 15-05-2014 by M.Moriche \n
%       Modified
%
% \details
%
% Output files of the IBcode are contain information
%  in HDF5 format.
%
% The structure of the file is:
%
%    basename.ifr.extension for the numbered files
%
%  TUCAN generates the following structure of directory/files
%
%  path
%   |-basenm
%       |-basenm.00001.h5frame   <--- THIS IS A NUMBERED FILE
%       |-basenm.00001.h5raw     <--- THIS IS A NUMBERED FILE
%       |-basenm.sta             <--- THIS IS NOT A NUMBERED FILE
%       |-basenm.war             <--- THIS IS NOT A NUMBERED FILE
%       |-basenm.err             <--- THIS IS NOT A NUMBERED FILE
%
%  MANDATORY ARGUMENTS:
%  - path: directory where the analysis is saved
%  - basenm: reference name of the file
%  - ext: extension of the file
%  - ifrpos: position of the index in the elements
%
%  OPTIONAL ARGUMENTS:
%  - ifr=[]: index of the file (if it has). It can be initialized
%            without ifr.
%
%  PROPERTIES:
%  - path
%  - basenm
%  - ifr
% 
%  PROPERTIES PROTECTED
%   elements
%   joiner
%   regexByElement
%   ifrpos
%   ext
%   regex
%   regex_ifr
%   frmt
%
%  METHODS:
%  - getfilformat()
%  - getfilename()
%  - getfullfilename()
%
%  EXAMPLES:
%  @code
%  f = NumberedFile('/home/mmoriche/data/IBcode/urv','urv_1',2,'h5frame')
%  f = NumberedFile('/home/mmoriche/data/IBcode/urv','urv_1',2,'h5frame','ifr',10)
%
%  fnm = f.getfilename();
%  @endcode
%
%

properties
   path
   basenm
   ifr 
end 
% end properties

properties(Access='protected')
   elements = {'basenm','ifr','ext'};
   joiner = '.'
   regexByElement = struct( ...
                    'basenm' , '(\w*?)',...
                    'ifr'    , '(\d+?)',...
                    'ext'    , '(\w*?)',...
                    'joiner' ,  '\.')
end
properties(Hidden=true)
   ifrpos
   regex
   regex_ifr
   ext
   frmt
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
methods

function self = NumberedFile(path,basenm,ext,ifrpos,varargin)
   %
   %  MANDATORY ARGUMENTS:
   %  - path: reference name of the analysis
   %  - basenm: reference name of the analysis
   %  - ext: Extension of the file
   %
   %  OPTIONAL ARGUMENTS:
   %  - path = '.': directory where the simulation is saving the files
   %  - ifr  =-1  : unnumbered file
   %  - joiner='.': join string between elements of the filename

   ifr = [];
   misc.assigndefaults(varargin{:});

   n = length(self.elements) - 1;
   self.regex = '';
   for i = 1:n
      self.regex = [self.regex self.regexByElement.(self.elements{i})];
      self.regex = [self.regex self.regexByElement.joiner];
   end
   self.regex     = [self.regex self.regexByElement.(self.elements{end})];

   self.regex_ifr = ['(' basenm ')' ...
                     self.regexByElement.joiner ...
                     self.regexByElement.ifr ...
                     self.regexByElement.joiner ...
                     '(' ext ')'];


   self.path = path;
   self.basenm = basenm;
   self.ext = ext;
   self.ifr = ifr;
   self.ifrpos = ifrpos;

   self.getfileformat();

return
end

function stat = getfileformat(self)

   [narray stat] = misc.getformatlength(self.regex,'path',fullfile(self.path,self.basenm));
   if stat == 0
      self.frmt=['%s' self.joiner '%0' num2str(narray(self.ifrpos)) 'd' self.joiner '%s'];
   else
      misc.warningmessage('File format not found');
   end

return
end

function fnm = getfilename(self)
  
   fnmels = {};
   for i = 1:length(self.elements)
      el = self.(self.elements{i});
      fnmels = [fnmels el];
   end
   fnm = sprintf(self.frmt, fnmels{:});
   
return
end

function fnm = getfullfilename(self)
  
   fnmels = {};
   for i = 1:length(self.elements)
      el = self.(self.elements{i});
      fnmels = [fnmels el];
   end
   fnm = sprintf(self.frmt, fnmels{:});
   fnm = fullfile(self.path, self.basenm, fnm);
return
end

end  % end methods
end  % end classdef