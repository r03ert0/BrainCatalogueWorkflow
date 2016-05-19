function [cont_grad_v,grad_v,tangent_basis,tg_basis,aires,norm_tri,norm_coord,index1,index2]=matrices_contraintes_ter(tri,coord,dim);
% Computation of the regularizing part in the variationnal approach (SS grad(v_k)grad(v_k')) and
% other geometrical quantities.
%
% Ref: Lefèvre J, Baillet S, Optical flow and advection on 2 Riemannian
% manifolds: A common framework, IEEE PAMI, 2008
%
% INPUTS :
% tri : triangles of the tesselation
% coord : coordinates of the tesselation
% dim : 3, scalp or cortical surface, 2 flat surface
%%%%%
% OUTPUTS :
% cont_grad_v : regularizing matrix
% grad_v : gradient of the basis functions in Finite Element Methods
% tangent_basis : basis of the tangent plane at a node of the surface
% (nodes are listed according to the tesselation)
% tg_basis : basis of the tangent plane at a node
% aires : area of the triangles
% norm_tri : normal of each triangle
% norm_coord : normal at each node
% index1, index2 : 

%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@chups.jussieu.fr    |
%|                                      | 
%\--------------------------------------/

nbr_capt=size(coord,1); % Number of nodes

%% Geometric quantities

[grad_v,aires,norm_tri]=carac_tri(tri,coord,dim);
norm_coord=carac_coord(tri,coord,norm_tri); 

%% basis of the tangent plane

[tg_basis]=ortho_basis(norm_coord,'uniform');

tangent_basis=cell(2,3); % quite the same structure as grad_v, 2=number of basis vector, 3=nodes of each triangulation 

tangent_basis{1,1}=tg_basis(tri(:,1),:,1);
tangent_basis{1,2}=tg_basis(tri(:,2),:,1);
tangent_basis{1,3}=tg_basis(tri(:,3),:,1);

tangent_basis{2,1}=tg_basis(tri(:,1),:,2);
tangent_basis{2,2}=tg_basis(tri(:,2),:,2);
tangent_basis{2,3}=tg_basis(tri(:,3),:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Regularizing matrix SS grad(v_k)grad(v_k') %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
index1=[];   
index2=[];
termes_diag=[];
tang_scal_11=[];
tang_scal_22=[];
tang_scal_12=[];
tang_scal_21=[];
for k=1:3, 
    for j=k+1:3
       index1=[index1,tri(:,k)];
       index2=[index2,tri(:,j)];
       tang_scal_11=[tang_scal_11,sum(tangent_basis{1,k}.*tangent_basis{1,j},2).*sum(grad_v{k}.*grad_v{j},2).*aires];
       tang_scal_22=[tang_scal_22,sum(tangent_basis{2,k}.*tangent_basis{2,j},2).*sum(grad_v{k}.*grad_v{j},2).*aires];
       tang_scal_12=[tang_scal_12,sum(tangent_basis{1,k}.*tangent_basis{2,j},2).*sum(grad_v{k}.*grad_v{j},2).*aires];
       tang_scal_21=[tang_scal_21,sum(tangent_basis{2,k}.*tangent_basis{1,j},2).*sum(grad_v{k}.*grad_v{j},2).*aires];
    end
    termes_diag=[termes_diag,sum(grad_v{k}.^2,2).*aires]; 
end

D=sparse(tri,tri,termes_diag,nbr_capt,nbr_capt);

E11=sparse(index1,index2,tang_scal_11,nbr_capt,nbr_capt);
E11=E11+E11'+D;
E22=sparse(index1,index2,tang_scal_22,nbr_capt,nbr_capt);
E22=E22+E22'+D;
E12=sparse(index1,index2,tang_scal_12,nbr_capt,nbr_capt);
E21=sparse(index1,index2,tang_scal_21,nbr_capt,nbr_capt);

E121=E12+E21';
E212=E121';

cont_grad_v=[E11 E121;E212 E22];

