function [X,A2,G]=heat_equation(X_0,U_0,faces,vertices,n,tau,A2,G)
% Implements heat equation with finites elements method 
%
% INPUTS :
% X_0 : initial activity
% U_0 : boundary conditions
% faces, vertices : triangles and nodes of the mesh
% n : number of steps for iterating
% tau : step of time in the temporal discretization
%
% OUTPUTS :
% X : activity from time 1 to time n
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@chups.jussieu.fr    |
%|                                      | 
%\--------------------------------------/
if nargin<7
[A2,G,grad_v,aires,index1,index2]=heat_matrices(faces,vertices,3,1);
end
% old stuff... probably wrong
% C=constant_term(faces,vertices,U_0,grad_v,aires);

% Implicit scheme
% G(X^(n+1)-X^n)/tau+A2(X^(n+1))=C 
% WARNING c'est pas A*C ??!!

if isempty(U_0)
    % Dirichlet homogène
    Y=X_0;
    M=G+tau*A2;
    for ii=1:n
        Y=G*Y;
        Y=M\Y;
        if n==1
            X=Y;
        else
            X(:,ii)= Y;
        end
    end
else
    FV.faces=faces;
    FV.vertices=vertices;
    N=size(vertices,1);
    VertConn=vertices_connectivity(FV);
    % Dirichlet non homogène implicte
    Y=X_0;
    M=G+tau*A2;

    indices=find(U_0)';
    diff_indices=setdiff(1:N,indices);
    B=M(diff_indices,indices);
    M(indices,diff_indices)=0;
    M(diff_indices,indices)=0;
    for ii=1:length(indices)
        M(indices(ii),indices(ii))=1;
        M(indices(ii),VertConn{indices(ii)})=0;
        M(VertConn{indices(ii)},indices(ii))=0;
    end
    for jj=1:n
        Y=G*Y;
        Y(indices)=U_0(indices);
        %Y(setdiff(1:n,indices))=M(setdiff(1:n,indices),setdiff(1:n,indices))\(Y(setdiff(1:n,indices))-M(setdiff(1:n,indices),indices)*U_0(indices));
        Y(diff_indices)=(Y(diff_indices)-B*U_0(indices));
        Y=M\Y;
        X(:,jj)= Y;
    end
%     % Dirichlet non homogène explicte
%     Y=X_0;
%     N=eye(size(FV.vertices,1))-tau*A2;
%     M=G;
%     indices=find(U_0)';
%     
%     B=M(setdiff(1:n,indices),indices);
%     M(indices,setdiff(1:n,indices))=0;
%     M(setdiff(1:n,indices),indices)=0;
%     for ii=indices
%         M(ii,ii)=1;
%         M(ii,VertConn{ii})=0;
%         M(VertConn{ii},ii)=0;
%     end
%     for jj=1:n
%         Y=N*Y;
%         Y(indices)=U_0(indices);
%         %Y(setdiff(1:n,indices))=M(setdiff(1:n,indices),setdiff(1:n,indices))\(Y(setdiff(1:n,indices))-M(setdiff(1:n,indices),indices)*U_0(indices));
%         Y(setdiff(1:n,indices))=(Y(setdiff(1:n,indices))-B*U_0(indices));
%         Y=M\Y;
%         X(:,jj)= Y;
%         jj
%     end
end

return

% With a differential equation :
% AX'+BX=0
% X(t)=exp(-A\Bt)X_0
% X=exp(-n*A\B)*X_0;

% 29/09/2008
% Test conditions de Dirichlet

% ligne 392 pure elastic : FV
% FV=sphere_tri('',4);

X_0=zeros(size(FV.vertices,1),1);
X_0(1)=1;
[X]=heat_equation(X_0,X_0,FV.faces,FV.vertices,100,0.1);

%%%%% 
% Version explicite
n=200;
dt=1e-2;
Y=X_0;
for ii=1:n
    Ytmp=G\(A2*Y);
   Y=Y-dt*Ytmp;
end