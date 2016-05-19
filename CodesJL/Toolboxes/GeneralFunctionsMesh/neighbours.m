function [neigh,Vneigh]=neighbours(m,FV,k,condition,Vneigh)
% function [neigh,Vneigh]=neighbours(m,FV,k)
% ---------------------------------------------
% Neighbours gives all the nodes of FV which are linked to the node m with less than
% k edges.
% ----------------------------------------------
% INPUTS :
% - FV : Tesselation with the fields faces, vertices
% - m : indice of a node
% - k : maximal number of edges joining m to any nodes in neigh
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

n=length(FV.vertices);
if nargin<5
    Vneigh=sparse(n,2); %
end
Vneigh(m,1)=1; % nombre de coups pour la propagation
Vneigh(m,2)=1; % pour vérifier s'il y a eu exploration. 1: initialisation 0 : à traiter, -1 : traité, 
[Vneigh]=find_neighbours2(Vneigh,FV.faces,FV.vertices,k,condition);
neigh=find(Vneigh(:,1));

function [Vneigh]=find_neighbours2(seed,tri,coord,kneigh,condition)

border=seed;
%Fneigh=[];

k=1;
nzborder=find(border(:,2)==1); % 
while k<=kneigh

    k=k+1   ;
    bordernext=[];
    for b=1:length(nzborder)
        [i,j]=find(tri==nzborder(b));
        %Fneigh=unique([Fneigh;i]);
        tritemp=tri(i,:);
        tritemp=unique(tritemp(:));
        % condition éventuelle if ... 
        i=intersect(find(border(tritemp,2)==0),find(condition(tritemp)));
        bordernext=[bordernext;tritemp(i)];
        border(tritemp(i),2)=-1;
        border(tritemp(i),1)=k;

    end

    nzborder=bordernext;
end
Vneigh=border;