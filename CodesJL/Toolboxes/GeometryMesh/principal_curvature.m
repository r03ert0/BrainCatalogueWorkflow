function [curvatures,check_normalization]=principal_curvature(FV,vertConn,options)
% INPUTS
% - FV: mesh (fields .vertices and .faces)
% - vertConn: connectivity of each vertex
% - options: no more used
%
% OUTPUTS
% - curvatures: nx2 arrays with fields Kmin and Kmax
%
% from Taubin, 1995
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr    |
%|                                      | 
%\--------------------------------------/

if nargin==2
    options.taubin='off';
end

[grad,aires,vectoriel]=carac_tri(FV.faces,FV.vertices,3);
curvatures=zeros(length(FV.vertices),2);

% 1) by vertex normals

w_normals=repmat(aires,1,3).*vectoriel; % weighted normals
normals=zeros(length(FV.vertices),3);

for t=1:length(FV.faces)
    for k=1:3
        sommets=FV.faces(t,k);
        normals(sommets,:)=normals(sommets,:)+w_normals(t,:);
    end
end

normals=normals./sqrt(repmat(sum(normals.^2,2),1,3));

% 2) Matrice de Weingarten

Id=eye(3,3);
check_normalization=zeros(length(FV.vertices),1);
directions=zeros(length(FV.vertices),3,2);
for ii=1:length(FV.vertices)
    neighs=vertConn{ii};
    [tri_i,~]=find(FV.faces==ii);
    M=zeros(3,3);
    norm_factor=2*sum(aires(tri_i));
    for j=1:length(neighs)
        Pij=(FV.vertices(neighs(j),:)-FV.vertices(ii,:))';
        Tij=-(Id-normals(ii,:)'*normals(ii,:))*Pij;
        Tij=Tij/norm(Tij);
        kappaij=2*normals(ii,:)*Pij/(norm(Pij)^2);
        %wij=1/length(neighs); 
        % to start, slighlty more complicated in Taubin's article. With 1/|neighs| it assumes all triangles have same areas
        %if isequal(options.taubin,'on')
            
            [tri_j,~]=find(FV.faces==neighs(j));
            tri_ij=intersect(tri_i,tri_j);
            wij=sum(aires(tri_ij))/norm_factor;
            check_normalization(ii)=check_normalization(ii)+wij;
        %end
        M=M+wij*kappaij*Tij*Tij';
    end
    [V,D]=eig(M);
    % to compute principal directions -> longer but we can obtain Kmin,
    % Kmax
    %vp=sort(diag(D)); not good
    D=diag(D);
    [vmin,indmin]=min(abs(D));
    vp=sortrows([D(setdiff([1 2 3],indmin)) [1 2]']);
    
    
    curvatures(ii,1)=3*vp(2,1)-vp(1,1);
    curvatures(ii,2)=3*vp(1,1)-vp(2,1);
%     directions(ii,:,1)=V(:,vp(1,2))';
%     directions(ii,:,2)=V(:,vp(2,2))';
    
end