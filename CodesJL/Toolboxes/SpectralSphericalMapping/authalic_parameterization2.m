function [nFV]=authalic_parameterization2(FV,N,sphFV)
% INPUTS: 
%   - FV: mesh with fields faces, vertices
%   - sphFV: spherical mesh to initialize the iterative process (optional)
%
% OUTPUTS:
%   - nFV: spherical mesh that tries to preserve initial areas
%
% Adapted from Authalic Parameterization of General Surfaces Using Lie Advection
% Guangyu Zou, Jiaxi Hu, Xianfeng Gu, and Jing Hua, IEEE TVG, 2011
% 
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

% A) Scaling
aires=tri_area(FV.faces,FV.vertices);
aires_s=tri_area(sphFV.faces,sphFV.vertices);

FV.vertices=FV.vertices/sqrt(sum(aires));
init_scaling=sqrt(sum(aires_s));
sphFV.vertices=sphFV.vertices/init_scaling;

aires=tri_area(FV.faces,FV.vertices);
aires_s=tri_area(sphFV.faces,sphFV.vertices);
Radius=sqrt(1/(4*pi));

% B) Geometry

[A2,G]=heat_matrices(FV.faces,FV.vertices,3,1);

if nargin<2
    [V,D]=eigs(A2,G,4,'sm');
    sphFV.faces=FV.faces;
    sphFV.vertices=V(:,1:3);
    sphFV.vertices=sphFV.vertices./sqrt(repmat(sum(sphFV.vertices.^2,2),1,3));
end

tic
[V,D]=eigs(A2,G,100,'sm');
toc

% C) Main loop

nFV=sphFV;
%tmp_aires=aires;
for ii=1:N
    % 1) Areal ratio factor
    aires_s=tri_area(nFV.faces,nFV.vertices);  
    %r=aires_s'./tmp_aires';
    %r=tmp_aires'./aires_s';
    %r=aires'./aires_s';
    r=aires_s'./aires';
    dh=(r-1)/(N-ii+1);
    %dh=(aires_s'-aires')/(N-ii+1);
    %dh=(aires_s'-1)/(N-ii+1);
        % from triangles to vertices
    dh2=vert2tri(FV,dh);   
    disp(['Areal ratio factor. Mean:',num2str(mean((r))) ,' Std:',num2str(std((r))), ' Min:',num2str(min((r))) ,' Max:',num2str(max((r)))])
    
    % 2) Poisson equation, Laplacian(g)=dh
    %[A2,G]=heat_matrices(nFV.faces,nFV.vertices,3,1);

    g=A2\(G*dh2);
    g=g-mean(g); % nabla(g) will be invariant to translation
    disp('Poisson equation')
    
    % 3) Gradient vector field, V=nabla(g)
    %grad_g=scalar_field_gradient(g,nFV);
    %X=heat_equation(g,[],nFV.faces,nFV.vertices,10,0.001); % regularization to prevent high gradients
    grad_g=scalar_field_gradient_optim(g,nFV);
    disp('Gradient vector field')
    
    % 4) Apply V to the spherical mesh
    nFV.vertices=nFV.vertices+grad_g;    
    nFV.vertices=Radius*nFV.vertices./repmat(sqrt(sum(nFV.vertices.^2,2)),1,3);
    
    %tmp_aires=aires_s;
    disp(['Step ',num2str(ii)])
end

nFV.vertices=nFV.vertices*init_scaling;
