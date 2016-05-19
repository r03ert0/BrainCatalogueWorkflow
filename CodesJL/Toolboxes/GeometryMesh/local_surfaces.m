function [surfaces,Ait]=local_surfaces(FV,k)

%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

% 1) Adjacency matric 
[~,~,A]=neighbours2(1,FV,1);

% 2) Propagation
Ait=speye(length(FV.vertices));
for ii=1:k
   Ait=A*Ait; 
end

Ait=(Ait>0);

% 3) From triangle areas to local areas
areas=tri_area(FV.faces,FV.vertices);
tmp=(Ait(:,FV.faces(:,1))+Ait(:,FV.faces(:,2))+Ait(:,FV.faces(:,3)))/3;
surfaces=tmp*areas';