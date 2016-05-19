function [normalf,normal] = mesh_normals(vertices,faces)

% compute_normal - compute the normal of a triangulation
%
%   [normal,normalf] = compute_normal(vertex,face);
%
%   normal(i,:) is the normal at vertex i.
%   normalf(j,:) is the normal at face j.
%
%   Copyright (c) 2004 Gabriel Peyr�

%vertex=FV.vertices';
%face=FV.faces';
%[vertex,face] = check_face_vertex(vertex,face);

nface = size(faces,1);
nvert = size(vertices,1);
normal = zeros(nvert,3);

% unit normals to the faces
normalf = crossp( vertices(faces(:,2),:)-vertices(faces(:,1),:), ...
                  vertices(faces(:,3),:)-vertices(faces(:,1),:) );
d = sqrt( sum(normalf.^2,2) ); d(d<eps)=1;
normalf = normalf ./ repmat( d, 1,3 );
if nargout>1
    % unit normal to the vertex
    normal = zeros(nvert,3);
    for i=1:nface
        f = faces(i,:);
        for j=1:3
            normal(f(j),:) = normal(f(j),:) + normalf(i,:);
        end
    end
    % normalize
    d = sqrt( sum(normal.^2,2) ); d(d<eps)=1;
    normal = normal ./ repmat( d, 1,3 );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function z = crossp(x,y)
% x and y are (m,3) dimensional
z = x;
z(:,1) = x(:,2).*y(:,3) - x(:,3).*y(:,2);
z(:,2) = x(:,3).*y(:,1) - x(:,1).*y(:,3);
z(:,3) = x(:,1).*y(:,2) - x(:,2).*y(:,1);
