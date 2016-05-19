function [values, n_lat, n_ver, time] = load_tex(tex_in)
% Read AIMS texture file
% [values, n_lat, n_ver] = read_tex(tex_in) ;
% values is [n_lat]x[n_ver] matrix giving the value at each of the
% [n_ver] vertex and at each time step

[pathstr, name, format] = fileparts(tex_in);

if ismember(lower(format),{'.gii'})
    g=gifti(tex_in);
    values=double(g.cdata)';
    n_lat=size(values,1);
    n_ver=size(values,2);
    time='Unknown';
else

%%% Open output file
  fid = fopen (tex_in, 'r') ;
  if fid== -1, error(sprintf('[load_tex] Cannot open %s.',tex_in)); end

  %%% First read header
  %%% File format ASCII / BINAR
  [file_format, COUNT] = fread(fid, 9, '*char') ;
  file_format=char(file_format(:))';
  if strcmp((file_format), 'binarDCBA')
    %%% Reads carriage return
    tmp_b = fread(fid, 1,'*int32');
    %Read type String length
    tmp_c = fread(fid, double(tmp_b), '*char');
    
    %%% Read Number of latencies
    n_lat = fread(fid, 1, '*int32') ;
    
    for i=1:n_lat
      %%%% Read latency step
      time(i)=fread(fid, 1, '*int32') ;
      
      %%%% read vertex number
      n_ver = fread(fid,1,'*int32') ;
      
      %%%% Allocate values if i==1
      if i==1
    	values = zeros(n_lat,n_ver) ;
      end
      %%%% Data
      switch tmp_c'
          case 'S16'
              values(i,:)= fread(fid, double(n_ver), '*int16')';
          case 'FLOAT'
              values(i,:)= fread(fid, double(n_ver), 'float');
      end
      
    end
    
  else
    [carriagereturn]=fgets(fid)
    [texture_type]=fgetl(fid)  
    switch texture_type
     case 'S16'
      datatype='%f'
     case 'FLOAT'
      datatype='%f'
     case 'U32'
      datatype='%d'
     case 'POINT2DF'
      datatype='%f'      
     otherwise
      error(sprintf('Unknown type in %s', mfilename))
      return
    end
    nt=str2num(fgetl(fid));
    for t=1:nt
      [s]=fgetl(fid)
      [time(t) nv v]=strread(s, datatype)
    end
    
  end
  fclose(fid); 
    if fid == -1, error(sprintf('[load_tex] Cannot close %s.',tex_in)); end
  fprintf('readtex donne : **file_format = %s\t **type = %s\t **n_lat = %d\t **n_ver = %d\n',file_format,tmp_c,n_lat,n_ver);
end
