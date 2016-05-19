function save_volume(filename,vol,type)

if nargin<3
    if isfield(vol,'type')
        type=vol.type;
        if strcmp(type,'double')
                disp('[save_volume] IN VOLUME type is double, but I save in float!!')
                type='FLOAT';
        end
    else
        disp('[save_volume] no IN VOLUME type available')
        str = class(vol.mat);
        switch str
            case 'uint16'
                type='S16';
            case 'uint8'
                type='U8';
            case 'float'
                type='FLOAT';
            case 'double'
                %type='DOUBLE';
                disp('[save_volume] type is double, but I save in float!!')
                type='FLOAT';
            otherwise
                error('[save_volume] Unknown output format.');
        end
    end
end

[pathstr, name, ext] = fileparts(filename);

if strcmp(ext,'.ima')
    save_ima(filename,vol,type,'binar');
elseif strcmp(ext,'.img')||strcmp(ext,'.nii')
    disp('[save_volume] not yet supported format :/')
else
    disp('[save_volume] bad file extension')
end
