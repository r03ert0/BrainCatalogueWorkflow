function OUTPUTS=mesh_spectral_clustering(INPUTS)
% Performs spectral clustering of a mesh based on LBO eigenfunctions
% INPUTS
% - mesh: filename or mesh structure (with fields faces, vertices)
% - K: number of clusters (default = 6)
% - clustering_options: MaxIter (150), Replicate (5)
% - save: to save the resulting texture or not
%
% OUTPUTS
% - V: LBO eigenfunctions used
% - IDX: segmentation map (filename or array)

% 1) Load mesh and options
if ~isfield(INPUTS,'mesh')
   disp('The field "mesh" has to be filled') ;
   return;
end

if isstr(INPUTS.mesh)
    FV=load_mesh(INPUTS.mesh);
else
    if ~isfield(INPUTS.mesh,'faces') || ~isfield(INPUTS.mesh,'vertices')
        disp('Fields "faces" or "vertices" are absent');
        return
    else
       FV=INPUTS.mesh; 
    end
end

if ~isfield(INPUTS,'K')
    K=6;
else
    K=INPUTS.K;
end

if ~isfield(INPUTS,'clustering_options')
    MaxIter=150;
    Replicate=5;
else
    MaxIter=INPUTS.clustering_options.MaxIter;
    Replicate=INPUTS.clustering_options.Replicate;
end

% 2) Laplace Beltrami Operator
[A2,G]=heat_matrices(FV.faces,FV.vertices,3,1);

% 3) Spectral decomposition
[V,D]=eigs(A2,G,K+1,'sm');

% 4) Clustering
opts = statset('Display','final','MaxIter',MaxIter);
IDX=kmeans(V(:,end-K+1:end),K,'Distance','sqeuclidean','Replicate',Replicate,'Options',opts);

% 5) Outputs
OUTPUTS.V=V;
OUTPUTS.IDX=IDX;

if isfield(INPUTS,'save')
    if isstr(INPUTS.save)
        OUTPUTS.filename=INPUTS.save;
    else
        indice=findstr(INPUTS.mesh,'.');
        OUTPUTS.filename=[INPUTS.mesh(1:indice-1),'_lobes.tex'];
    end
    save_tex(IDX',1,length(IDX),OUTPUTS.filename,'S16')
end
