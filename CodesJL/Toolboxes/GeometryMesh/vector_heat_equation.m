function [heatV,M,Energy]=vector_heat_equation(V,faces,vertices,n,lambda)
% Implements vectorial heat equation with finites elements method 
%
% Ref: Lefèvre J, Baillet S, Optical flow and advection on 2 Riemannian
% manifolds: A common framework, IEEE PAMI, 2008
%
% INPUTS :
% V : initial vector field
% faces, vertices : triangles and nodes of the mesh
% n : number of steps for iterating
% lambda : parameter of the discretization
%
% OUTPUTS :
% heatV : activity from time 1 to time n
% M : matrix involved in the discretization
% 
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@chups.jussieu.fr    |
%|                                      | 
%\--------------------------------------/

if nargin<5
    lambda=1;
end

[B,A,aires,index1,index2]=heat_matrices(faces,vertices,3,1);
clear B aires index1 index2
[cont_grad_v,grad_v,tangent_basis,tg_basis,aires,norm_tri,norm_coord,index1,index2]=matrices_contraintes_ter(faces,vertices,3);

dim=size(A,1);

nullA=sparse(dim,dim);
AA=[A nullA; nullA A];

Y=V;
M=(AA+lambda*cont_grad_v);
for ii=1:n
    Y=AA*Y;
    Y=M\Y;
end

Energy=Y'*cont_grad_v*Y;

heatV=repmat(Y(1:dim),[1,3]).*tg_basis(:,:,1)+repmat(Y(dim+1:2*dim),[1,3]).*tg_basis(:,:,2);

% return
% 
% % Visu
% 
% view_surface('lapin',FV.faces,FV.vertices)
% hold on
% 
% norV=sqrt(sum(heatV.^2,2));
% indices=find(norV);
% quiver3(FV.vertices(:,1),FV.vertices(:,2),FV.vertices(:,3),heatV(indices,1)./norV(indices),heatV(indices,2)./norV(indices),heatV(indices,3)./norV(indices),'g')
% 
% % Quelques calculs
% m=5867; % occipital : 7204, sillon central :6440
% n=size(NFV.vertices,1);
% V_1=zeros(n*2,1);
% V_1(m)=1;
% heatV1=vector_heat_equation(V_1,NFV.faces,NFV.vertices,1);
% V_2=zeros(n*2,1);
% V_2(m+n)=1;
% heatV2=vector_heat_equation(V_2,NFV.faces,NFV.vertices,1);
% 
% 
% %scal12=sum(heatV1.*heatV2,2)./(sqrt(sum(heatV1.^2,2).*sum(heatV2.^2,2)));
% 
% norV1=sqrt(sum(heatV1.^2,2));
% indices1=find(norV1);
% norV2=sqrt(sum(heatV2.^2,2));
% indices2=find(norV2);
% indices=intersect(indices1,indices2);
% scal12=zeros(n,1);
% scal12(indices,:)=sum(heatV1(indices,:).*heatV2(indices,:),2)./(norV1(indices).*norV2(indices));
% 
% heatV=heatV1;
% norV=sqrt(sum(heatV.^2,2));
% indices=find(norV);
% quiver3(NFV.vertices(indices,1),NFV.vertices(indices,2),NFV.vertices(indices,3),heatV(indices,1)./norV(indices),heatV(indices,2)./norV(indices),heatV(indices,3)./norV(indices),'g')
% 
% heatV=heatV2;
% norV=sqrt(sum(heatV.^2,2));
% indices=find(norV);
% quiver3(NFV.vertices(indices,1),NFV.vertices(indices,2),NFV.vertices(indices,3),heatV(indices,1)./norV(indices),heatV(indices,2)./norV(indices),heatV(indices,3)./norV(indices),'Color',[0 0 0])
% 
% 
% % With a differential equation :
% % AX'+BX=0
% % X(t)=exp(-A\Bt)X_0
% 
% X=exp(-n*A\B)*X_0;
% 
% view_surface