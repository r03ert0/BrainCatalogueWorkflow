function [distance,table]=distance_partititon(type,P,Q)

% INPUTS:
% - type: 'Jaccard', 'Rand'
% - For P and W, there can be one input: contingency table
% or 
% two partitions, given as arrays of size Nx1 with integer values denoting
% labels of each subset


if nargin==3
    M=length(unique(P));
    N=length(unique(Q));
    table=zeros(M,N);
    for ii=1:M
        for jj=1:N          
            %table(ii,jj)=length(intersect(find(P==ii) , find(Q==jj)));
            %%slow
            table(ii,jj)=sum((P==ii).*(Q==jj));
        end
    end
else
    table=P;
end

n=sum(sum(table));

a=1/2*sum(sum(table.*(table-1)));
b=1/2*(sum((sum(table,1)).^2)-sum(sum(table.^2)));
c=1/2*(sum((sum(table,2)).^2)-sum(sum(table.^2)));
d=1/2*(n^2+sum(sum(table.^2))-sum((sum(table,1)).^2)-sum((sum(table,2)).^2));

switch type
    case 'Jaccard'
        distance=(b+c)/(a+b+c);
    case 'Rand'
        distance=(b+c)/(a+b+c+d);
    otherwise
        disp('not yet defined');
        return;
end