% @author M.Moriche
%
% @date 30-10-2014  by M.Moriche \n
%       Added Geometry
%
auxByHeader = struct( ...
  'Reynolds', struct('head','$\mathrm{Re}$',...
               'headascii','Re',...
               'pattern','$%d$',...
               'patternascii','%d',...
               'fields',{{'Re'}}), ...
  'Processes', struct('head','Total procs.',...
                'headascii','nproc',...
                'pattern','$%d$',...
                'patternascii','%d',...
                'fields' ,{{'nproc'}}),...
  'Process_partition',struct('head','procs. in $X$ x procs. in $Y$',...
                        'headascii','ndx x ndy',...
                        'pattern','$%d$ x $%d$',...
                        'patternascii','%d x %d',...
                        'fields' ,{{'ndx','ndy'}}),...
  'Grid_size',struct('head','$N_x$ x $N_y$',...
               'headascii','nx x ny',...
               'pattern','$%d$ x $%d$',...
               'patternascii','%d x %d',...
               'fields' ,{{'nx','ny'}}),...
  'Time_step',struct('head','$\Delta t$',...
               'headascii','dt',...
               'pattern','$%.4E$',...
               'patternascii','%.4E',...
               'fields' ,{{'dt'}}),...
  'Mesh_width',struct('head','$\Delta x$ x $\Delta y$',...
                'headascii','dx x dy',...
                'pattern','$%.4E$ x $%.4E$',...
                'patternascii','%.4E x %.4E',...
                'fields' ,{{'dx','dy'}}),...
  'Resolution',struct('head','pts. per $L_c$',...
                'headascii','pts per Lc',...
                'pattern','$%d$',...
                'patternascii','%d',...
                'fields' ,{{'dx'}},...
                'operation' ,'mylist{1} = round(1./mylist{1});'),...
  'Domain',struct('head','[$x_0$ $x_f$] x [$y_0$ $y_f$]',...
            'headascii','[x0 xf] x [y0 yf]',...
            'pattern','[$%.2f$ $%.2f$] x [$%.2f$ $%.2f$]',...
            'patternascii','[%.2f %.2f] x [%.2f %.2f]',...
            'fields' ,{{'x0','xf','y0','yf'}}),...
  'Geometry',struct('head','geometry',...
            'headascii','geometry',...
            'pattern','%s',...
            'patternascii','%s',...
            'fields' ,{{'geomfilename'}},...
            'operation' ,'[caca mylist{1}] = fileparts(mylist{1});mylist{1} = strrep(mylist{1},''_'',''\_'');'),...
  'MAS_h_y',struct('head','$h_y$',...
            'headascii','h_y',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(1)'}}),...
  'MAS_frequency',struct('head','$k$',...
            'headascii','k',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(2)'}}),...
  'MAS_h_th',struct('head','$h_\theta$',...
            'headascii','h_th',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(3)'}}),...
  'MAS_phi',struct('head','$\phi$',...
            'headascii','phi',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(4)'}}),...
  'MAS_x_pivot',struct('head','$x_{pivot}$',...
            'headascii','x_pivot',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(5)'}}),...
  'MASF_h_y',struct('head','$h/c$',...
            'headascii','h_y',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(1)'}}),...
  'MASF_frequency',struct('head','$k$',...
            'headascii','k',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(2)'}}),...
  'MASF_th_0',struct('head','$\theta_m(^\circ)$',...
            'headascii','th_0',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(3)'}},...
            'operation' ,'mylist{1} = mylist{1}*180/pi;'),...
  'MASF_h_th',struct('head','$\theta_0(^\circ)$',...
            'headascii','h_th',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(4)'}},...
            'operation' ,'mylist{1} = mylist{1}*180/pi;'),...
  'MASF_phi',struct('head','$\phi(^\circ)$',...
            'headascii','phi',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(5)'}},...
            'operation' ,'mylist{1} = mylist{1}*180/pi;'),...
  'MASF_x_pivot',struct('head','$x_{pivot}/c$',...
            'headascii','x_pivot',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(6)'}}),...
  'PLATEFLAP_amp',struct('head','$A$',...
            'headascii','A',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(1)'}}),...
  'PLATEFLAP_slope',struct('head','$m$',...
            'headascii','m',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(2)'}}),...
  'PLATEFLAP_toff',struct('head','$t_{off}$ ($c/U_\infty$)',...
            'headascii','t_off (c/Uinf)',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(3)'}}),...
  'PLATEFLAP_x_hinge',struct('head','$x_{hinge}$',...
            'headascii','x_hinge',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(4)'}}),...
  'cyl_shear',struct('head','$S$',...
            'headascii','S',...
            'pattern','$%.4f$',...
            'patternascii','%.4f',...
            'fields' ,{{'sdv(1)'}}));


