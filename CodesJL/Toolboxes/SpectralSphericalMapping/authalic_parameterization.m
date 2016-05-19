function [nFV]=authalic_parameterization(FV,N,sphFV)
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

[A2,G,grad_v,aires,index1,index2,cont_vv]=heat_matrices(sphFV.faces,sphFV.vertices,3,1);

if nargin<2
    [V,D]=eigs(A2,G,4,'sm');
    sphFV.faces=FV.faces;
    sphFV.vertices=V(:,1:3);
    sphFV.vertices=sphFV.vertices./sqrt(repmat(sum(sphFV.vertices.^2,2),1,3));
end


aires=tri_area(FV.faces,FV.vertices);
%aires=aires/sum(aires);
aires_s=tri_area(sphFV.faces,sphFV.vertices);
ratio=sqrt(sum(aires)/sum(aires_s));

nFV=sphFV;
nFV.vertices=sphFV.vertices*ratio;
tmp_aires=aires;
for ii=1:N
    % 1) Areal ratio factor
    aires_s=tri_area(nFV.faces,nFV.vertices);  
    %r=aires_s'./tmp_aires';
    %r=tmp_aires'./aires_s';
    r=aires'./aires_s';
    r=aires'./aires
    dh=(r-1)/(N-ii+1);
    %dh=(aires_s'-aires')/(N-ii+1);
        % from triangles to vertices
    dh2=vert2tri(nFV,dh);   
    disp(['Areal ratio factor. Mean:',num2str(mean((r))) ,' Std:',num2str(std((r))), ' Min:',num2str(min((r))) ,' Max:',num2str(max((r)))])
    
    % 2) Poisson equation, Laplacian(g)=dh
    g=A2\(G*dh2);
    g=g-mean(g); % nabla(g) will be invariant to translation
    disp('Poisson equation')
    
    % 3) Gradient vector field, V=nabla(g)
    %grad_g=scalar_field_gradient(g,nFV);
    grad_g=scalar_field_gradient_optim(g,nFV);
    disp('Gradient vector field')
    
    % 4) Apply V to the spherical mesh
    nFV.vertices=nFV.vertices+grad_g;    
    nFV.vertices=nFV.vertices./repmat(sqrt(sum(nFV.vertices.^2,2)),1,3);
    
    tmp_aires=aires_s;
    disp(['Step ',num2str(ii)])
end

