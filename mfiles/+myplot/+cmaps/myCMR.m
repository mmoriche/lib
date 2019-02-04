function cc=myCMR(ii)

cc = myplot.cmaps.CMR;

r = interpn(1:65,cc(:,1),ii(:));
g = interpn(1:65,cc(:,2),ii(:));
b = interpn(1:65,cc(:,3),ii(:));

cc = [r g b];

return
end
