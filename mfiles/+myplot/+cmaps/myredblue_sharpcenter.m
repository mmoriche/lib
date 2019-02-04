function cmap = myredblue_sharpcenter()

cyan = [0 1 1];
blue = [0 0 1];
red = [1 0 0];
darkblue = [0 0 0.5];
darkred = [0.5 0 0];
lightblue = [0.6 0.6 1];
lightred  = [1 0.6 0.6];
white = [1 1 1];
coral = [1 0.488 0.3137];
gold = [1.0000    0.8431         0];
tomato = [1 0.3882 0.2784];
green = [0 1 0];
black = [0.2 0.2 0.2];
black = [0.6 0.6 0.6];
blackblue = [0.6 0.6 0.8];
blackred = [0.8 0.6 0.6];

colors = [darkblue;
          blue; 
          lightblue; 
          white; 
          white; 
          lightred;
          red;
          darkred];

values = [-1 -0.6666 -0.15 -0.001 0.001 0.15 0.66666 1];
cmap = myplot.linearcmap(values, colors);
return
end
