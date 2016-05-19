function [trm]=load_trm(file_trm)

fid2 = fopen(file_trm,'r');
if fid2== -1, error(sprintf('[load_trm] Cannot open %s.',file_trm)); end

line1 = fscanf(fid2,'%f',3);
line2 = fscanf(fid2,'%f',3);
line3 = fscanf(fid2,'%f',3);
line4 = fscanf(fid2,'%f',3);
M=[line2,line3,line4];
trm=[M',line1];
trm(4,:)=[0 0 0 1];
fclose(fid2); 
if fid2 == -1, error(sprintf('[load_trm] Cannot close %s.',file_trm)); end