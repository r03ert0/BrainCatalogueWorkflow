function save_minf(file_minf,minf_txt)
fid2 = fopen(file_minf,'w');
if fid2== -1, error(sprintf('[save_minf] Cannot open %s.',file_minf)); end
for l=1:length(minf_txt)
    fprintf(fid2,'%s',minf_txt{l});
end
fclose(fid2); 
if fid2 == -1, error(sprintf('[save_minf] Cannot close %s.',file_minf)); end