function [vol] = load_volume(filename,verbose_mode)

if nargin==0
    [f, pathname] = uigetfile({'*.ima'},'Pick a file');
    filename = [pathname,f];
end

if nargin<2
    verbose_mode=1;
end
recomp=0;
[pathstr, name, ext] = fileparts(filename); 
if strcmp(ext,'.gz')
    disp('uncompressing the .gz')
    system(['gunzip ',filename]);
    filename=fullfile(pathstr,name);
    recomp=1;
    [~, ~, ext] = fileparts(filename); 
end
if strcmp(ext,'.ima')
    [vol] = load_ima(filename);
elseif strcmp(ext,'.img')||strcmp(ext,'.nii')
    v_tmp=nifti(filename);
    vol.dim_mat=size(v_tmp.dat(:,:,:));
    vol.mat=reshape(v_tmp.dat(:,:,:),vol.dim_mat(1)*vol.dim_mat(2)*vol.dim_mat(3),1);
    vol.vox_size=round(10000*diag(v_tmp.mat(1:3,1:3))')/10000;
%    vol.type%%%% TODO
    if verbose_mode
        disp('nifti')
    end
else
    disp('[load_volume] bad file extension, return Nan')
    vol=Nan;
end

if recomp
   disp('recompressing the .gz')
   system(['gzip ',filename]);
end
if isstruct(vol)&&verbose_mode
    fprintf('------------------------------------------------------\n');
    fprintf('%s\n',filename);
    fprintf('x_dim = %d\t y_dim = %d\t z_dim = %d\n',vol.dim_mat(1),vol.dim_mat(2),vol.dim_mat(3));
    fprintf('dx = %f\t dy = %f\t dz = %f\n',vol.vox_size(1),vol.vox_size(2),vol.vox_size(3));
    fprintf('------------------------------------------------------\n');
end
