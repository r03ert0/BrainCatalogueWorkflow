function [norm_coord]=carac_coord(tri,coord,norm_tri)
% Normal at each node of the tesselation
% INPUTS :
% tri : triangles
% coord : coordinates of each node
% norm_tri : normal of each triangle
norm_coord=zeros(size(coord,1),3);
for i=1:size(tri,1)
    for k=1:3
        norm_coord(tri(i,k),:)=norm_coord(tri(i,k),:)+norm_tri(i,:);
    end
end

norm_coord=norm_coord./repmat(sqrt(sum(norm_coord.^2,2)),1,3);

% Not very satisfying solution to the problem of pathological anatomy

indices=find(isnan(norm_coord));
norm_coord(indices)=0;