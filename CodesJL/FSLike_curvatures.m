function [inflatedH,curv,sulc,smoothedFV]=FSLike_curvatures(FV,normalize,nsmooth,niter,tau,VERBOSE)

if nargin<3
    nsmooth=100;
    niter=10;
    tau=0.1;
    VERBOSE=1;
end

options.rot=-1;

% Curvature of the original surface (curv)
VertConn=vertices_connectivity(FV);
[~,curvature]=curvature_cortex(FV,VertConn,1,0);
% Curvature of the smoothed surface (inflate.H)
[smoothedFV,A]=smooth_cortex(FV,VertConn,0.9,nsmooth);
[~,scurvature]=curvature_cortex(smoothedFV,VertConn,1,0);
% Convexity (sulc)
normals=vertex_normals(FV);
normals=normals';
displacement=FV.vertices-smoothedFV.vertices;
signe=sum(normals.*displacement,2);
sulc=sign(signe).*sqrt(sum(displacement.^2,2));

% Smoothing
curv=smooth_cortical_maps(FV,-curvature,niter,tau,VERBOSE,options);
inflatedH=smooth_cortical_maps(smoothedFV,-scurvature,niter,tau,VERBOSE,options);

if normalize
   curv=(curv-mean(curv))/std(curv); 
   inflatedH=(inflatedH-mean(inflatedH))/std(inflatedH);
   sulc=(sulc-mean(sulc))/std(sulc);
end