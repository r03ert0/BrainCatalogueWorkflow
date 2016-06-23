function [FV, FVh1, FVh2] = hemi_cut(specie, hemi)

% Toolboxes
ToolboxFolder='Toolboxes/';
addpath(genpath(ToolboxFolder))
addpath('../matlab/extensions/fieldtrip/currentversion/public/')

% Data
[vertices,faces]=read_ply(['../BrainCatalogueWorkflow/meshes_centered/' specie '/' hemi '.ply']);
FV.faces=faces;
FV.vertices=[vertices.x, vertices.y, vertices.z];

% LBO eigenfunctions
N=20;
[A2,G,~,aires]=heat_matrices(FV.faces,FV.vertices,3,1);
tic;[V,D]=eigs(A2,G,N,'sm');toc
[posneg,VertConn]=nodal_sets_count(FV,V,1,N);


% %% Principal curvatures
% hs=my_view_surface(FV);
% normals=get(hs,'VertexNormals');
% [curvatures,directions]=curvature_fit(FV,0,'quadr',normals);
% lambda=100;
% figure
% [~,~,~,heatV]=visu_curvature(FV,curvatures,directions,lambda);

%% Hemispheric cut #1
indices=find(V(:,end-1)>0);
[FVh1,Transfo]=convert_patch(indices,FV); 
[A2,G,~,aires]=heat_matrices(FVh1.faces,FVh1.vertices,3,1);
tic;[Vh1,Dh1]=eigs(A2,G,N,'sm');toc
Nh1 = normals(FVh1.vertices, FVh1.faces, 'T');

%% Hemispheric cut #2
indices=find(V(:,end-1)<0);
[FVh2,Transfo]=convert_patch(indices,FV); 
[A2,G,~,aires]=heat_matrices(FVh2.faces,FVh2.vertices,3,1);
tic;[Vh2,Dh2]=eigs(A2,G,N,'sm');toc
Nh2 = normals(FVh2.vertices, FVh2.faces, 'T');


%% clustering
% INPUTS.mesh=FVh1; %or FVh1, FVh2
% INPUTS.K=4;
% OUTPUTS=mesh_spectral_clustering(INPUTS);
% options.angle=[-90 0];
% option.rot=-1;
% figure
% my_view_surface(FVh1,-OUTPUTS.IDX,options)
% view(100,10)


%save the variables
%save('/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/JL_Toolboxes_v1.2/hemi.mat', 'FV', 'FVh1', 'FVh2', 'INPUTS', 'OUTPUTS', 'posneg', 'option')

%save the surfaces

write_ply(['../BrainCatalogueWorkflow/meshes_centered/' specie '/right.ply'], FVh1.vertices, FVh1.faces, 'ascii')
write_ply(['../BrainCatalogueWorkflow/meshes_centered/' specie '/left.ply'], FVh2.vertices, FVh2.faces, 'ascii')

%write_vtk(['../../surfaces/' specie '/left.vtk'], FVh1.vertices, FVh1.faces)
%write_vtk(['../../surfaces/' specie '/right.vtk'], FVh2.vertices, FVh2.faces)

%write_stl(['../../surfaces/' specie '/left.stl'], FVh1.vertices, FVh1.faces, Nh1)
%write_stl(['../../surfaces/' specie '/right.stl'], FVh2.vertices, FVh2.faces, Nh2)
%check if left and right actually correspond!!


end