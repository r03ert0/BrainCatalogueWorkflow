function [grad_U_vertex,grad_U]=scalar_field_gradient(U,FV)
% Compute the gradient of a function U on a mesh, at the vertex or face
% level
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr    |
%|                                      | 
%\--------------------------------------/


[grad_v,aires]=carac_tri(FV.faces,FV.vertices,3);
hs=patch(FV);
normals=get(hs,'VertexNormals');
normals=normals./repmat(sqrt(sum(normals.^2,2)),1,3);
close all;
tri=FV.faces;
% face based
grad_U=repmat(U(tri(:,1)),1,3).*grad_v{1}+repmat(U(tri(:,2)),1,3).*grad_v{2}+repmat(U(tri(:,3)),1,3).*grad_v{3};
grad_U=repmat(aires,1,3).*grad_U;

% normals: at each vertex
[VertFaceConn,Pn]=vertices_faces_connectivity(FV,normals);

% vertex based
grad_U_vertex=tri2vert(grad_U,VertFaceConn,Pn); 