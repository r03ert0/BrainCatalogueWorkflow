function [random_distances,random_rotations]=random_textures(sFV,textures,Nrandom)
% INPUTS
% - sFV: spherical mesh
% - sillons: multi-dimensional texture with discrete values
% - labels: discrete values that are represented in sillons
% - Nrandom: number of random rotations


if nargin<5
    Nrandom=100;
end
random_indices=zeros(Nrandom,1);
random_rotations=zeros(3,3,Nrandom);

start_time=tic;
for r=1:Nrandom
    for k=1:length(labels)
        if k==1
            [rsillons(:,k),random_rotations(:,:,r)]=random_partitions(sFV,double(sillons==labels(k))');
        else
            rsillons(:,k)=random_partitions(sFV,double(sillons==labels(k))',random_rotations(:,:,r));
        end
        random_distances(r,k)=mean(D(find(rsillons(:,k))));
    end
end
toc(start_time)