function B=incidence_matrix(FV)
% INPUTS:
% - FV: mesh, M faces, N vertices
% OUTPUTS:
% - B: NxM sparse matrix, incidence matrix

n=size(FV.vertices,1);
m=size(FV.faces,1);
i1=[];
i2=[];
val=[];
for k=1:3
    i1=[FV.faces(:,k);i1];
    i2=[(1:m)';i2];
    val=[ones(length(FV.faces),1);val];
end
B=sparse(i1,i2,val,n,m);