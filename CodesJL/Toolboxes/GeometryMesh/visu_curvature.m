function [curvatures2,directions,FV,heatV,Energy]=visu_curvature(filename,curvatures2,directions,lambda)
% Different visualization of curvature fields:
% -Curvatures can be pre-computed (curvatures2)
% -They can smoothed (thaks to parameter lambda)
% -Mean curvature is represented as a texture unless directions=[]
% 
% INPUTS:
% - filename: name of a file or mesh structure with fields faces, vertices
% - curvatures2: values of principal curvatures
% - directions: principal directions (vectors)
% - lambda: if nonempty, give the strength of the regularization of the
% direction field
%
% OUTPUTS:
% - curvatures, directions, FV: can be obtained if not specified as Inputs
% - heatV: smoothed direction field
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr    |
%|                                      | 
%\--------------------------------------/

if isstr(filename)
    [vertex,face] = read_ply(filename);
    FV.faces=face;
    FV.vertices=vertex;
else
    FV=filename; 
end

if nargin<2
    [curvatures2,directions]=curvature_fit(FV,0,'quadr');
    curvatures2=sort(curvatures2,2,'descend');
end

if nargin<4
    heatV=directions;
else
    [cont_grad_v,grad_v,tangent_basis,tg_basis,aires,norm_faces,norm_vertices,index1,index2]=matrices_contraintes_ter(FV.faces,FV.vertices,3);
    n=length(FV.vertices);
    heatV=zeros(n,3,2);
    for cp=1:2 % the 2 principal curvatures
        V=zeros(2*n,1);
        V(1:n)=sum(directions(:,:,cp).*tg_basis(:,:,1),2);
        V(n+1:2*n)=sum(directions(:,:,cp).*tg_basis(:,:,2),2);
        [heatV(:,:,cp),~,Energy(cp)]=vector_heat_equation(V,FV.faces,FV.vertices,1,lambda);
        heatV(:,:,cp)=heatV(:,:,cp)./repmat(sqrt(sum(heatV(:,:,cp).^2,2)),1,3); % normalization
    end
end

if length(curvatures2)<length(FV.vertices)
    texture=ones(length(FV.vertices),1);
else
    texture=sum(curvatures2,2); % mean curvature
end
p=patch(FV);
set(p,'FaceColor','interp',...
'FaceVertexCData',texture,...
'EdgeColor','none')
camlight('infinite')
lighting phong
hold on

if isempty(heatV)
else
    quiver3(FV.vertices(:,1),FV.vertices(:,2),FV.vertices(:,3),heatV(:,1,1),heatV(:,2,1),heatV(:,3,1),2,'k','Marker','none')
end
shading interp
axis vis3d
axis equal
axis off
set(gcf,'Color','White')