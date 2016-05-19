function [texture_out]=skeletonisation_mesh(FV,texture_in,vertConn)
% INPUTS:
% - FV: mesh
% - texture_in: Nx1 vector
% OUTPUTS:
% - texture_out: Nx1 vector

% Connected components of texture_in
if nargin<3
    vertConn=vertices_connectivity(FV);
end

map=texture_in;
texture_out=zeros(length(texture_in),1);
cpt=1;
while sum(map)>0
    op_map=opening_mesh(FV,map,vertConn); % opening
    texture_out=texture_out+map-op_map; % residual
    map=erosion_mesh(FV,map,vertConn);
    cpt
    cpt=cpt+1;
end