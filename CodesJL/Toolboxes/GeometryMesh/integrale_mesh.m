function [integrale]=integrale_mesh(FV,aires,f)
% Computes the integral of a function f defined on a mesh FV
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

integrale=0;
for tt=1:length(FV.faces)
   triangle=FV.faces(tt,:);
   integrale=integrale+aires(tt)*(f(triangle(1))+f(triangle(2))+f(triangle(3)))/3;
end