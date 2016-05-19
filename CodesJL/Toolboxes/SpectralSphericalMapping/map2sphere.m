function [sphFV,V,nd_c,VertConn,D]=map2sphere(FV,indices,VertConn,V)
%--------------------------------------------------------------------
% Spherical mapping with the three first eigenfunctions of a mesh
%
% Ref: Lefèvre J., Auzias G., Spherical Parameterization for genus
% zero surfaces using Laplace-Beltrami eigenfunctions, Proceedings GSI, 
% 2015
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

% 4 first LBO eigenfunctions computation
if nargin<4
    [A2,G,grad_v,aires,index1,index2,cont_vv]=heat_matrices(FV.faces,FV.vertices,3,1);
    [V,D]=eigs(A2,G,4,'sm');
end

% Reorient if necessary, to raise the +1/-1 ambiguity on the sign of
% eigenfunctions

for ii=1:3
    [~,indm]=min(V(:,ii));
    [~,indM]=max(V(:,ii));
    
    if FV.vertices(indm,indices(ii))>FV.vertices(indM,indices(ii))
        tmp=indm;
        indm= indM;
        indM=tmp;
        V(:,ii)=-V(:,ii);
    end
end

% Mapping on sphere

sphFV.faces=FV.faces;
sphFV.vertices=V(:,1:3);
sphFV.vertices=sphFV.vertices./sqrt(repmat(sum(sphFV.vertices.^2,2),1,3));


if nargin>=3
    if size(VertConn)==1
        nd_c=[0 0 0];
    else
        % Compute the number of nodal domains of each eigenfunction
        [posneg,VertConn]=nodal_sets_count(FV,V,1,3,VertConn);
        nd_c=sum(posneg');
    end
end

