function labels(xtext, ytext, varargin)

fs = 32;
misc.assigndefaults(varargin{:});

if strcmp(xtext([1 end]), '$$')
   xlabel(xtext, 'FontSize', fs, 'Interpreter', 'latex');
else
   xlabel(xtext, 'FontSize', fs);
end

if strcmp(xtext([1 end]), '$$')
   ylabel(ytext, 'FontSize', fs, 'Interpreter', 'latex');
else
   ylabel(ytext, 'FontSize', fs);
end
set(gca, 'FontSize', fs);

return
end
