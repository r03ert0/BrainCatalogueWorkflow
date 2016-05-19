function [curvature,directions]=curvature_fit(FV,th,type)
% Computes the principal curvatures of a mesh by using a local quadratic or
% cubic fit.
% 
% Ref: S. Petitjean, A survey of methods for recovering quadrics 
% in triangle meshes, ACM Computing Surveys, 2002
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

hs=patch(FV);
normals=get(hs,'VertexNormals');
close all;

condition=ones(size(FV.vertices,1),1);
curvature=zeros(size(FV.vertices,1),2);
directions=zeros(length(FV.vertices),3,2);
for ii=1:size(FV.vertices,1)
    
    P=FV.vertices(ii,:)';
    n=normals(ii,:)';
    n=n/norm(n);
    Pr=(eye(3)-n*n');
    r1=Pr*[1;0;0];
     if norm(r1)==0
         r1=Pr*[0;1;0];
     end
    r1=r1/norm(r1);
    r2=cross(n,r1);
    R=[r1 r2 n]';
    neigh=neighbours(ii,FV,2,condition);
    
    X=FV.vertices(neigh,:)';
    XX=R*(X-repmat(P,1,length(neigh)));
    if isequal(type,'cubic')
        A=[XX(1,:)'.^2 XX(1,:)'.*XX(2,:)' XX(2,:)'.^2 XX(1,:)'.^3 XX(1,:)'.^2.*XX(2,:)' XX(1,:)'.*XX(2,:)'.^2 XX(2,:)'.^3];
    else
        A=[XX(1,:)'.^2 XX(1,:)'.*XX(2,:)' XX(2,:)'.^2];
    end
    parameters=pinv(A)*XX(3,:)';
%     curvature(ii,1)=parameters(1);
%     curvature(ii,2)=parameters(3);
    %ii
    M=[parameters(1) parameters(2)/2;parameters(2)/2 parameters(3)];
    [V,D]=eig(M);
    D=diag(D);
    %ind=sortrows([abs(D),[1 2]']);
    ind=[(1:2)' (1:2)'];
    directions(ii,:,1)=(R(ind(1:2,2),:)'*V(:,ind(1,2)))';
    directions(ii,:,2)=(R(ind(1:2,2),:)'*V(:,ind(2,2)))';
    curvature(ii,1)=D(ind(1,2));
    curvature(ii,2)=D(ind(2,2));
end

% Thresholding
if th
    m=min(curvature);
    M=max(curvature);
    [nb,x]=hist(curvature,m:(M-m)/10000:M);
    cnb=cumsum(nb);
    ind1=find(cnb<0.025*size(FV.vertices,1));
    ind1=ind1(end);
    ind2=find(cnb>0.975*size(FV.vertices,1));
    ind2=ind2(1);
    curvature(curvature<=x(ind1))=x(ind1);
    curvature(curvature>=x(ind2))=x(ind2);
end