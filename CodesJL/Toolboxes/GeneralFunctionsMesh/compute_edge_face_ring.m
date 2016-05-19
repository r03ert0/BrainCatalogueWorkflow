function A = compute_edge_face_ring(faces)

% compute_edge_face_ring - compute faces adjacent to each edge
%
%   e2f = compute_edge_face_ring(faces);
%
%   e2f(i,j) and e2f(j,i) are the number of the two faces adjacent to
%   edge (i,j).
%
%   Copyright (c) 2007 Gabriel Peyre


[tmp,faces] = check_face_vertex([],faces);

n = max(faces(:));
m = size(faces,2);
i = [faces(1,:) faces(2,:) faces(3,:)];
j = [faces(2,:) faces(3,:) faces(1,:)];
s = [1:m 1:m 1:m];

% first without duplicate
[tmp,I] = unique( i+(max(i)+1)*j );
% remaining items
J = setdiff(1:length(s), I);

% flip the duplicates
i1 = [i(I) j(J)];
j1 = [j(I) i(J)];
s = [s(I) s(J)];

% remove doublons
[tmp,I] = unique( i1+(max(i1)+1)*j1 );
i1 = i1(I); j1 = j1(I); s = s(I);

A = sparse(i1,j1,s,n,n);
clear i1 j1 i j I J tmp s faces
% add missing points
try
    I = find( A'~=0 );
    I = I( A(I)==0 );
    A( I ) = -1;
catch
    [i2,j2] = find( A'~=0 );
    for p=1:length(i2)
        I2(p)=(A(i2(p),j2(p))==0);
    end
    i3=find(I2);
    for p=1:length(i3)
        A(i2(i3(p)),j2(i3(p)))=-1;
    end
end

%A(A(A'~=0)~=0) = -1;


%  [i2,j2] = find( A'~=0 );
%  I2=diag((A(i2,j2)==0));
% 
% i2(I2)
% I2 = I2( A(I2)==0 ); 
% A( I2 )
% 
%  i3=find(I2);
%  for p=1:length(i3)
%  A(i2(i3(p)),j2(i3(p)))=-1;
%  end
% 
% 
%   I = find( A'~=0 );
%  I = I( A(I)==0 ); 
%   A( I ) = -1;