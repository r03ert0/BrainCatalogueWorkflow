function save_trm(file_trm,trm)

line2 = trm(1,1:3);
line3 = trm(2,1:3);
line4 = trm(3,1:3);
line1 = trm(1:3,4);

fid2 = fopen(file_trm,'w');
if fid2== -1, error(sprintf('[save_trm] Cannot open %s.',file_trm)); end

fprintf(fid2,'%f %f %f\n',line1(1),line1(2),line1(3));
fprintf(fid2,'%f %f %f\n',line2(1),line2(2),line2(3));
fprintf(fid2,'%f %f %f\n',line3(1),line3(2),line3(3));
fprintf(fid2,'%f %f %f\n',line4(1),line4(2),line4(3));

if fid2 == -1, error(sprintf('[save_trm] Cannot close %s.',file_trm)); end