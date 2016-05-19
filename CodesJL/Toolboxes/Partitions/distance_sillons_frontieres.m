function [correspondances]=distance_sillons_frontieres(FV,idx_sillon,idx_frontieres)
% INPUTS: 
%   - FV: mesh with fields faces, vertices
%   - idx_sillon: indices of points (subset of vertices) that belong to a given sulcus
%   - idx_frontieres: indices of points of boundaries (subset of vertices)
%
% Algo:
% For each point of a sulcus
%       Find the pt of boundaries that minimize the distance
% Sum all the distances for each point of the sulcus
%
% Tenir compte du fait que les frontieres sont de plus en plus nombreuses
% au fur et à mesure que K augmente

correspondances=zeros(length(idx_sillon),2);
for ii=1:length(idx_sillon)
    pt=FV.vertices(idx_sillon(ii),:);
    [d,ind]=min(((pt(1)-FV.vertices(idx_frontieres,1)).^2+...
        (pt(2)-FV.vertices(idx_frontieres,2)).^2+...
        (pt(3)-FV.vertices(idx_frontieres,3)).^2)); % geodesic distance would be better
    correspondances(ii,1)=sqrt(d);
    correspondances(ii,2)=ind;
end