function [value1 value2] = getvalue2(self, varnm_1, varnm_2)


%misc.assigndefaults(varargin{:});
ifrlist = self.ifrlist;

% get dimensions
nnlist_1 = zeros(length(ifrlist), 1);
nnlist_2 = zeros(length(ifrlist), 1);

n0list = zeros(length(ifrlist), 1);

for i0 = 1:length(ifrlist)

   ifr = ifrlist(i0);
   self.nf.ifr = ifr;
   fnm = self.nf.getfullfilename();
   dims_1 = io.getdimensions(fnm, varnm_1);
   n0list(i0) = dims_1(1);

   nnlist_1(i0) = prod(dims_1);
   n2list_1(i0) = prod(dims_1(2:end));

   dims_2 = io.getdimensions(fnm, varnm_2);
   nnlist_2(i0) = prod(dims_2);
   n2list_2(i0) = prod(dims_2(2:end));

end

n0 = sum(n0list);
nn_1 = sum(nnlist_1);
nn_2 = sum(nnlist_2);
value_1 = zeros(nn_1,1);
value_2 = zeros(nn_2,1);

ioff = length(ifrlist);

ia0_1 = 1;
ia0_2 = 1;
for i0 = 1:length(ifrlist)

   ifr = ifrlist(i0);
   self.nf.ifr = ifr;
   fnm = self.nf.getfullfilename();

   vv = io.geth5dset(fnm, varnm_1);
   vv2 = reshape(vv, n0list(i0), n2list_1(i0));

   ia = ia0_1;
   for i2 = 1:n2list_1(i0)
      ib = ia + n0list(i0)-1;
      value_1(ia:ib) = vv2(:,i2);
      ia = ia + n0;
   end
   ia0_1 = ia0_1 + n0list(i0);

   vv = io.geth5dset(fnm, varnm_1);
   vv2 = reshape(vv, n0list(i0), n2list_1(i0));

   ia = ia0_2;
   for i2 = 1:n2list_2(i0)
      ib = ia + n0list(i0)-1;
      value_2(ia:ib) = vv2(:,i2);
      ia = ia + n0;
   end
   ia0_2 = ia0_2 + n0list(i0);

end


if length(dims_1) == 1
   newdims = [n0 1];
else
   newdims = [n0 dims_1(2:end)]
end

value_1 = reshape(value_1, newdims);

if length(dims_2) == 1
   newdims = [n0 1];
else
   newdims = [n0 dims_2(2:end)]
end

value_2 = reshape(value_2, newdims);

return
end




