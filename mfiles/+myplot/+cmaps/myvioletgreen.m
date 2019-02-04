function cmap = myvioletgreen()
               
darkpurple   =[64, 0, 127]/255;
lightpurple  =[111, 0, 255]/255;

darkgreen   = [0 0.8 0];
lightgreen  = [0 1 0];


values = [-1 -0.7 -0.01 0.01 0.7 1];
white = [1 1 1];

clrs = [darkpurple;...
        lightpurple; ...
        white; ...
        white; ...
        lightgreen; ...
        darkgreen];
cmap =  myplot.linearcmap(values, clrs);
colormap(cmap)


cmap = myplot.linearcmap(values, clrs);
return
end
