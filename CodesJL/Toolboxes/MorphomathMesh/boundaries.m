function [texture_out,A]=boundaries(FV,texture_in)
% INPUTS:
% - FV: mesh
% - texture_in: Nx1 vector
% OUTPUTS:
% - texture_out: Nx1 vector
% - A: NxN sparse matrix, adjacency matrix

A=adjacency_matrix(FV);
texture_out=(A-diag(sum(A)))*texture_in;