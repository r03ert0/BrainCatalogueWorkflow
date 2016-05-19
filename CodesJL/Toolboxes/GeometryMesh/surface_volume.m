function [vol,vol2]=surface_volume(FV,V)

% Calcul du volume inclus dans une surface à l'aide du théorème
% d'Ostrogradski en prenant pour champ de vecteurs Id/3

% Calcul, sur les triangles

[grad_v,aires,norm_tri]=carac_tri(FV.faces,FV.vertices,3);

if nargin<2
    
    % On divise par 3 une première fois pour avoir le barycentre, puis une
    % deuxième fois pour avoir le Id/3 !!!!!
    V=(FV.vertices(FV.faces(:,1),:)+FV.vertices(FV.faces(:,2),:)+FV.vertices(FV.faces(:,3),:))/9;
    
end

vol=sum(V.*norm_tri,2).*aires;
vol=sum(vol);

% Autre calcul, sur les vertex

% hs=my_view_surface('',FV.faces,FV.vertices);
% normals=get(hs,'VertexNormals');
% close all
% 
% for ii=1:size(FV.vertices,1)
%     triangles=TriConn{ii};
%     vol2(ii)=sum(V(ii,:).*normals(ii,:),2)*sum(aires(triangles))/3;
% end

% Autre calcul, vertex/triangle

% Autre calcul, en prenant pour champ de vecteur (x,0,0)


V2=zeros(size(V));

V2(:,1)=3*V(:,1);
vol2=sum(V2.*norm_tri,2).*aires;
vol2=sum(vol2);

return

% Vérification du calcul avec une sphère 

rayon=[0.25:0.25:5];

for n=1:length(rayon)
   SFV= sphere_tri('ico',4,rayon(n));
   TriConn=faces_connectivity(SFV);
   volume_sphere(n)=surface_volume(SFV,TriConn);
   100*n/length(rayon)
end