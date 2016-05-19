function A=adjacency_matrix(FV,weighted)
% INPUTS:
% - FV: mesh
% OUTPUTS:
% - A: NxN sparse matrix, adjacency matrix

if nargin<2
    weighted=0;
end

i1=[];
i2=[];
val=[];
for k=1:3
    for l=k+1:3
        i1=[FV.faces(:,k);i1];
        i2=[FV.faces(:,l);i2];
        if weighted
            ddist=FV.vertices(FV.faces(:,k),:)-FV.vertices(FV.faces(:,l),:);
            ddist=sqrt(sum(ddist.^2,2));
            val=[ddist;val];
        else
            val=[ones(length(FV.faces),1);val];
        end
    end
end
n=size(FV.vertices,1);
A=sparse(i1,i2,val,n,n);
A=A+A';