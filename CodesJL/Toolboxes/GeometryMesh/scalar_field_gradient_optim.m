function [grad_U_vertex,grad_U]=scalar_field_gradient_optim(U,FV)
% Compute the gradient of a function U on a spherical mesh, at the vertex or face
% level
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/


[grad_v,aires]=carac_tri(FV.faces,FV.vertices,3);
%normals=FV.vertices; % only for the sphere
close all;
tri=FV.faces;
% face based
grad_U=repmat(U(tri(:,1)),1,3).*grad_v{1}+repmat(U(tri(:,2)),1,3).*grad_v{2}+repmat(U(tri(:,3)),1,3).*grad_v{3};
%grad_U=repmat(aires,1,3).*grad_U;

grad_U_vertex=vert2tri(FV,grad_U);

