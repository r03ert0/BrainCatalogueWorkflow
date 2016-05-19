function [texture_out]=opening_mesh(FV,texture_in,vertConn)
% INPUTS:
% - FV: mesh
% - texture_in: Nx1 vector
% OUTPUTS:
% - texture_out: Nx1 vector

% Connected components of texture_in
if nargin<3
    vertConn=vertices_connectivity(FV);
end

% Erosion, Dilation

[texture_out]=erosion_mesh(FV,texture_in,vertConn);
[texture_out]=dilation_mesh(FV,texture_out,vertConn);