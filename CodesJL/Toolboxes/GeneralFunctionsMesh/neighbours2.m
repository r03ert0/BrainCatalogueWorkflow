function [neigh,Vneigh,A]=neighbours2(m,FV,k,A)
% function [neigh,Vneigh]=neighbours(m,FV,k)
% ---------------------------------------------
% Neighbours gives all the nodes of FV which are linked to the node m with less than
% k edges.
% ----------------------------------------------
% INPUTS :
% - FV : Tesselation with the fields faces, vertices
% - m : indice of a node
% - k : maximal number of edges joining m to any nodes in neigh
% - A : adjecency matric
% OUTPUTS :
% - neigh : indices of the k-neighbourhood of m
% - Vneigh : n_vertices * 2. First column indicates the number of edges
%          between any node and m
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr    |
%|                                      | 
%\--------------------------------------/

% 1) Adjacency matrix
n=length(FV.vertices);
if nargin<4
    ind1=[];
    ind2=[];
    for i1=1:3
        for i2=i1+1:3
            ind1=[ind1;FV.faces(:,i1)];
            ind2=[ind2;FV.faces(:,i2)];
        end
    end
    A=sparse(ind1,ind2,ones(length(ind1),1),n,n);
    A=(A+A')/2;
end

% 2) Propagation

Vneigh=zeros(n,1);
Vneigh(m)=1;

for ii=1:k
   Vneigh=A*Vneigh; 
end
neigh=find(Vneigh);

% A2=A;
% crit=1;
% 
% for ii=1:k
%     Maux=M2;
%     M2=mult_graph(M2);
% end
