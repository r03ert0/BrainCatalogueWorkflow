function [minf_txt]=load_minf(file_minf)
fid2 = fopen(file_minf,'r');
if fid2== -1, error(sprintf('[load_minf] Cannot open %s.',file_minf)); end

l=1;
while ~feof(fid2)
minf_txt{l} =fgets(fid2);
l=l+1;
end

fclose(fid2); 
if fid2 == -1, error(sprintf('[load_minf] Cannot close %s.',file_minf)); end
