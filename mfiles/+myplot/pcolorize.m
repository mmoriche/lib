function [xo yo vvo] = pcolorize(xi, yi, vvi)

dimx = find(size(xi) ~= 1);
dimy = find(size(yi) ~= 1);

xo = xi(1:end-1) + 0.5*diff(xi);
xo = cat(dimx, xo(1) - (xo(2)-xo(1)), xo                );
xo = cat(dimx, xo        , xo(end) + (xo(end)-xo(end-1)));

yo = yi(1:end-1) + 0.5*diff(yi);
yo = cat(dimy, yo(1) - (yo(2)-yo(1)), yo                           );
yo = cat(dimy, yo                   , yo(end) + (yo(end)-yo(end-1)));

vvo = cat(1, vvi, vvi(1,:));
vvo = cat(2, vvo, vvo(:,1));

return
end

