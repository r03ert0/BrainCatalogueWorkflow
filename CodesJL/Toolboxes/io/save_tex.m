function save_tex(res, lat_number, vertex_number, tex_out,type)
% Write res as an antomist texture file - BrainVisa Version

%%% Store the results in Anatomist Texture files (event number inserted in out filenames)
fid = fopen (tex_out, 'w') ;
if fid== -1, error(sprintf('[save_tex] Cannot open %s.',tex_out)); end
%%%% header intialization left
fwrite(fid, 'binarDCBA', 'uchar');
switch type
    case 'S16'
        fwrite(fid,3,'uint32');
        fwrite(fid, 'S16', 'uchar');  
    case 'FLOAT'
        fwrite(fid,5,'uint32');
        fwrite(fid, 'FLOAT','uchar');
    otherwise
        error('[save_tex] Unknown output format.');
end
%%%% Number of latencies
fwrite(fid, lat_number,'uint32');

for i=1:lat_number
    %%%% Latencies (WARNING: index must start at 0 for anatomist)
    fwrite(fid, i-1, 'uint32') ;
    
    %%%% vertex number
    fwrite(fid,vertex_number,'uint32') ;
    
    %%%% Data
    switch type
        case 'S16'
            fwrite(fid, res(i,1:vertex_number),'uint16');
        case 'FLOAT'        
            fwrite(fid, res(i,1:vertex_number), 'float');
    end
end
fclose(fid);
if fid == -1, error(sprintf('[save_tex] Cannot close %s.',tex_out)); end
fclose all ;
return








