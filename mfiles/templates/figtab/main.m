% @author 
% @date        
%
%! @brief
%!
%! @details
%!
% @case ic=<ic>
%
% machine=<machine>
% dataset=<dataset>
%
% varlist=<-varlist->
%
% libs from <GITHUB>
% <|libs|>
%
close all
clearvars -except ic

%_______________________________________________________________________________ 
% INPUT
project='WORK/source/DUSNEK/tags/extendruns';

%_______________________________________________________________________________ 
% SETUP
% path to data and repositories
GITHUB=getenv('GITHUB_PATH');
TANK=getenv('TANK_PATH');

% output, mirror of this path 
EXTRA=misc.getextrapath(GITHUB);
otank=fullfile(TANK,EXTRA);

% input, project dependent
itank=fullfile(TANK,project,'post');

% load libraries
libs={'WORK/lib/mfiles', ...
      ''};
for i1 = 1:length(libs)
   addpath(fullfile(GITHUB,libs{i1}));
end

% Configuration of figures
cmap=[0,0,0;...
      1,0,0;...
      0,0,1;...
      0,0.7,0];
set(0,'defaultAxesColorOrder',cmap)
set(0,'defaultLineLineWidth',2)

%_______________________________________________________________________________ 
% case selector
if ~exist('ic'), help(mfilename), error('ic must be defined'); end
if ic == 1
   ...
elseif ic == 2
   ...
else
   error('wrong ic')
end

ansysnm=sprintf('%s-ic%d',mfilename,ic);

ifnmlist={};
ifnmlist=cat(1,ifnmlist,ifnm);

% FIGURES
rs=Results(ansysnm,otank,'auxfiles',false);

fig=figure()
   
ax=get(fig,'Children');
   
myplot.updateax(ax,'fsvf',1.5);
myplot.updateaxfig(fig,ax,'prxr',3,'wa',0.3);
   
cap=sprintf('velocity %s - dataset:%s',coords(i1),dataset);
indx=rs.addXYPlot(fig,'cap',cap,'indx',1000+i1);
rs.save('indxlist',indx,'frmt','eps');


rs.summ('longtable',true)
