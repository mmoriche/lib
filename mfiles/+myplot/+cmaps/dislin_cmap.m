function [] = dislin_cmap(colors,scheme,realprec)

ss = '     ';
N = length(colors);
fid = fopen([scheme '.f'], 'w');
fprintf(fid, '%s subroutine %s_%d_r%d(rr,gg,bb)\n', ss, scheme, N, realprec);
fprintf(fid, '%s implicit none\n', ss);
fprintf(fid, '%s real(%d), dimension(%d) :: rr,gg,bb\n', ss, realprec, N);
j = 1;
for i=1:N
    fprintf(fid, '%s rr(%3d) = %15.8E \n', ss, i, colors(i,j));
end
j = 2;
for i=1:N
    fprintf(fid, '%s gg(%3d) = %15.8E \n', ss, i, colors(i,j));
end
j = 3;
for i=1:N
    fprintf(fid, '%s bb(%3d) = %15.8E \n', ss, i, colors(i,j));
end
fprintf(fid, '%s endsubroutine %s_%d_r%d', ss, scheme, N, realprec);
fclose(fid);

end
