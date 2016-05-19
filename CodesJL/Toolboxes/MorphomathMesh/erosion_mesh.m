function [texture_out]=erosion_mesh(FV,texture_in,vertConn)
% INPUTS:
% - FV: mesh
% - texture_in: Nx1 vector
% OUTPUTS:
% - texture_out: Nx1 vector

% Connected components of texture_in
if nargin<3
    vertConn=vertices_connectivity(FV);
end

% Erosion of each component
texture_out=zeros(length(texture_in),1);
for ii=1:length(FV.vertices)
    neigh_k=vertConn{ii};
    val=1;
   for k=1:length(neigh_k)
       if texture_in(neigh_k(k))==0          
           val=0;
       end
       
   end
   texture_out(ii)=val;
end