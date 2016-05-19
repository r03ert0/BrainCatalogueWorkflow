function g=first_fundamental_form(tri,coord)

% Computes determinant of first fundamental form on each triangle
% INPUTS 
% tri : triangles of tesselation
% coord : coordinates of nodes
%
% OUTPUTS 
% g : determinant of first fundamental form on each triangle

% Edges of each triangles
u=coord(tri(:,2),:)-coord(tri(:,1),:);
v=coord(tri(:,3),:)-coord(tri(:,2),:);
w=coord(tri(:,1),:)-coord(tri(:,3),:);

g=sqrt(sum(u.^2,2).*sum(v.^2,2)-sum((u.*v),2).^2);
% h=sqrt(sum(u.^2,2).*sum(w.^2,2)-sum((u.*w),2).^2);
% f=sqrt(sum(w.^2,2).*sum(v.^2,2)-sum((w.*v),2).^2);