function hs=my_view_surface(FV,f,options)
% Visualization of a mesh and a function f over it
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

if nargin<2
    f=zeros(length(FV.vertices),1);
    options=[];
end

if nargin<3
    options=[];
end

if isfield(options,'rot')
    FV.vertices=FV.vertices*options.rot;
end

hs=patch(FV,'FaceVertexCData',f,'FaceColor','interp','EdgeColor','none')
axis equal
axis off
axis vis3d
set(gcf,'Color','w')
material shiny
lighting phong
if ~isfield(options,'angle')
    options.angle=[-90 0];
end
camlight(options.angle(1),options.angle(2),'infinite');
camlight(-options.angle(1),-options.angle(2),'infinite');