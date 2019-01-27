trifac = convhull(xyz(:,1), xyz(:,2), xyz(:,3));
trifac0 = trifac;

% Be sure that all triangles are oriented anti-clockwise with normals pointing 
% outwards
ntri = size(trifac,1);

% patch triangles
e1 = trifac(:,[1 2]);
e2 = trifac(:,[2 3]);
e3 = trifac(:,[3 1]);
e1 = sort(e1, 2);
e2 = sort(e2, 2);
e3 = sort(e3, 2);

et = cat(1, e1, e2, e3);
ee = zeros(0, 2);

for i1 = 1:size(et,1)
   ec = et(i1,:);
   if find(ec(1) == ee(:,1) & ec(2) == ee(:,2)); continue; end
   ee = cat(1, ee, ec);
end
% get over edges
iitochange = [];
newfaces  =  zeros(0, 3);
for i1 = 1:size(ee,1)
   iA = ee(i1,1);
   iB = ee(i1,2);
   [i2a j2] = find(trifac == iA );
   [i2b j2] = find(trifac == iB );
   i2 = intersect(i2a, i2b);
   tri1 = trifac(i2(1),:);
   tri2 = trifac(i2(2),:);
   iX = find(tri1 ~= iA & tri1 ~= iB);
   iY = find(tri2 ~= iA & tri2 ~= iB);
   iX = tri1(iX);
   iY = tri2(iY);

   xyzA = xyz(iA,:);
   xyzB = xyz(iB,:);
   xyzX = xyz(iX,:);
   xyzY = xyz(iY,:);

   [latA lonA hA ] = geocent_inv(xyzA(1), xyzA(2), xyzA(3), ss);
   [latB lonB hB ] = geocent_inv(xyzB(1), xyzB(2), xyzB(3), ss);
   [latX lonX hX ] = geocent_inv(xyzX(1), xyzX(2), xyzX(3), ss);
   [latY lonY hY ] = geocent_inv(xyzY(1), xyzY(2), xyzY(3), ss);
   
   [LAB dummy dummy] = geoddistance(latA,lonA,latB,lonB,ss);
   [LXY dummy dummy] = geoddistance(latX,lonX,latY,lonY,ss);

   if LAB > LXY 
      trifac(i2(1),:) = [iB iX iY];
      trifac(i2(2),:) = [iA iX iY];
   end
end

n = 0;
for i1 = 1:ntri
   x1 = xyz(trifac(i1,1),:);
   x2 = xyz(trifac(i1,2),:);
   x3 = xyz(trifac(i1,3),:);
   xm = mean(xyz(trifac(i1,:),:),1);
   v1 = x2 - x1;
   v2 = x3 - x2;
   vc = cross(v1,v2);
   vn = [2*A*xm(1), ...
         2*B*xm(2), ...
         2*C*xm(3)];
   mydot = dot(vc,vn);
   if mydot<0
      n = n + 1; 
      trifac(i1,:) = fliplr(trifac(i1,:));
   end
end
sprintf('a total of %d faces RE re-oriented', n)
