function [cont_grad_v,cont_v,grad_v,aires,index1,index2,cont_vv,B]=heat_matrices(tri,coord,dim,fff,f);
% Computation of the regularizing part in the variationnal approach (SS grad(v_k)grad(v_k')) and
% other geometrical quantities.
% INPUTS :
% tri : triangles of the tesselation
% coord : coordinates of the tesselation
% dim : 3, scalp or cortical surface, 2 flat surface
% f : anisotropy function in the diffusion
% fff : first fundamental form from previous time point (t-1)

%%%%%
% OUTPUTS :
% cont_grad_v : regularizing matrix
% grad_v : gradient of the basis functions in Finite Element Methods
% aires : area of the triangles
% index1, index2 :  lists of nodes for function sparse
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr    |
%|                                      | 
%\--------------------------------------/



nbr_capt=size(coord,1); % Number of nodes

%% Geometric quantities

[grad_v,aires,norm_tri]=carac_tri(tri,coord,dim);

g=first_fundamental_form(tri,coord); % first fundamental form at time t
clear norm_tri

if nargin<5
else
    for tt=1:length(tri)
        aires(tt)=aires(tt)*sum(f(tri(tt)))/3;
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Regularizing matrix SS grad(v_k)grad(v_k') %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
index1=[];   
index2=[];
termes_diag1=[];
termes_diag2=[];
termes_diag3=[];
termes_diag4=[];
mat1=[];
mat2=[];
mat3=[];
mat4=[];

for k=1:3, 
    for j=k+1:3
       index1=[index1,tri(:,k)];
       index2=[index2,tri(:,j)];
       mat1=[mat1,sum(grad_v{k}.*grad_v{j},2).*aires];
       mat2=[mat2,(1/12)*aires];
       mat3=[mat3,(1/30)*aires];
       mat4=[mat4,(1/12)*aires.*(log(g)-log(fff))];
    end
    termes_diag1=[termes_diag1,sum(grad_v{k}.^2,2).*aires];
    termes_diag2=[termes_diag2,(1/6)*aires];
    termes_diag3=[termes_diag3,(1/10)*aires];
    termes_diag4=[termes_diag4,(1/6)*aires.*(log(g)-log(fff))];
end

D1=sparse(tri,tri,termes_diag1,nbr_capt,nbr_capt);
D2=sparse(tri,tri,termes_diag2,nbr_capt,nbr_capt);
D3=sparse(tri,tri,termes_diag3,nbr_capt,nbr_capt);
D4=sparse(tri,tri,termes_diag4,nbr_capt,nbr_capt);

M1=sparse(index1,index2,mat1,nbr_capt,nbr_capt);
M2=sparse(index1,index2,mat2,nbr_capt,nbr_capt);
M3=sparse(index1,index2,mat3,nbr_capt,nbr_capt);
M4=sparse(index1,index2,mat4,nbr_capt,nbr_capt);

cont_grad_v=M1+M1'+D1;
cont_v=M2+M2'+D2;
cont_vv=M3+M3'+D3;
B=M4+M4'+D4;
