function [d,D]=graph_diameter(A)

% Gives diameter and all distances in a graph

n=length(A);
D=Inf*ones(n);
D(1:n+1:n^2)=0;
W=A+eye(n);
for k=1:n
    D(W>0)=min(k,(D(W>0)));
    W=A*W;
end
d=max(D(:));