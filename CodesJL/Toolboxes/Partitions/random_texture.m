function [r_textures,random_rotations]=random_textures(sFV,textures,Nrandom)
% INPUTS
% - sFV: spherical mesh
% - textures: multi-dimensional textures
% - Nrandom: number of random rotations


if nargin<3
    Nrandom=100;
end
random_rotations=zeros(3,3,Nrandom);
r_textures=zeros(size(textures,1),size(textures,2),Nrandom);
start_time=tic;
for r=1:Nrandom
    
    [r_textures(:,:,r),random_rotations(:,:,r)]=random_partitions(sFV,textures);
    
end
toc(start_time)