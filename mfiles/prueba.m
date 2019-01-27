close all
clear all

fnm = '/share/drive/mmoriche/data/IBcode/potential/ellipse/ellipse.0000000.h5frame';
io.geth5dsetlist(fnm, 'ux','xux','yux','xgrid','ygrid');

save potential.mat
