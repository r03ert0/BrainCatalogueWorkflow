function [grad,aires,vectoriel]=carac_tri(tri,coord,dim);
% Computes some geometric quantities from a surface
% INPUTS 
% tri : triangles of tesselation
% coord : coordinates of nodes
% dim : deefault 3, 2 for projection on a plane
%
% OUTPUTS 
% grad : gradient of basis function (Finite Elements Method) on each triangle
% aires : area of each triangle
% vectoriel : normal of each triangle 
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

% Edges of each triangles
u=coord(tri(:,2),:)-coord(tri(:,1),:);
v=coord(tri(:,3),:)-coord(tri(:,2),:);
w=coord(tri(:,1),:)-coord(tri(:,3),:);

% Length of each edges and angles bewteen edges
uu=sum(u.^2,2);
vv=sum(v.^2,2);
ww=sum(w.^2,2);
uv=sum(u.*v,2);
vw=sum(v.*w,2);
wu=sum(w.*u,2);

% 3 heights of each triangle and their norm
h1=w-((vw./vv)*ones(1,dim)).*v;
h2=u-((wu./ww)*ones(1,dim)).*w;
h3=v-((uv./uu)*ones(1,dim)).*u;
hh1=sum(h1.^2,2);
hh2=sum(h2.^2,2);
hh3=sum(h3.^2,2);

% Gradient of the 3 basis functions on a triangle 
grad=cell(1,dim);
grad{1}=h1./(hh1*ones(1,dim));
grad{2}=h2./(hh2*ones(1,dim));
grad{3}=h3./(hh3*ones(1,dim));

% Prevents from pathological gradients

indices1=find(sum(grad{1}.^2,2)==0|isnan(sum(grad{1}.^2,2)));
indices2=find(sum(grad{2}.^2,2)==0|isnan(sum(grad{2}.^2,2)));
indices3=find(sum(grad{3}.^2,2)==0|isnan(sum(grad{3}.^2,2)));
indices21=find(sum(grad{1}.^2,2));
indices22=find(sum(grad{2}.^2,2));
indices23=find(sum(grad{3}.^2,2));

min_norm_grad=min([sum(grad{1}(indices21,:).^2,2);sum(grad{2}(indices22,:).^2,2);sum(grad{3}(indices23,:).^2,2)]);

grad{1}(indices1,:)=repmat([1 1 1]/min_norm_grad,length(indices1),1);
grad{2}(indices2,:)=repmat([1 1 1]/min_norm_grad,length(indices2),1);
grad{3}(indices3,:)=repmat([1 1 1]/min_norm_grad,length(indices3),1);


% Area of triangles and normals of each triangle
aires=sqrt(hh1.*vv)/2;
indices=find(isnan(aires));
aires(indices)=0;
aires2=sqrt(hh2.*ww)/2;

if dim==3
    vectoriel=cross(w,u);
    vectoriel=vectoriel./repmat(sqrt(sum(vectoriel.^2,2)),1,3);
else
    vectoriel=[];
end


