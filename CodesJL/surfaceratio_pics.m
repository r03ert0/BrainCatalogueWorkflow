function [sr_5mm, sr_10mm, sr_15mm, sr_20mm, FV] = surfaceratio_pics(specie, hemi)
%function to save pics with surfaceratio with spheres of differet size

ToolboxFolder='/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/BrainCatalogueWorkflow/CodesJL/Toolboxes/';
addpath(genpath(ToolboxFolder))

[vertices,faces]=read_ply(['../meshes_centered/' specie '/' hemi '.ply']);
FV.faces=faces;
FV.vertices=vertices;

%% for both hemis
% sr_5mm = read_curv(['../meshes_centered/' specie '/surfaceratio/' hemi '.sratio_5mm.curv']);
% sr_10mm = read_curv(['../meshes_centered/' specie '/surfaceratio/' hemi '.sratio_10mm.curv']);
% sr_15mm = read_curv(['../meshes_centered/' specie '/surfaceratio/' hemi '.sratio_15mm.curv']);
% sr_20mm = read_curv(['../meshes_centered/' specie '/surfaceratio/' hemi '.sratio_20mm.curv']);


% angles=[-100 10;129 -40];

% fig_1 = figure(1);
% 
% subplot(2,2,1);
% title('5mm');
% my_view_surface(FV,sr_5mm);
% zoom(1.0);
% subplot(2,2,2);
% my_view_surface(FV,sr_5mm);
% view(angles(1,1),angles(1,2));
% zoom(1.9);
% 
% subplot(2,2,3);
% title('10mm');
% my_view_surface(FV,sr_10mm);
% zoom(1.0);
% subplot(2,2,4);
% my_view_surface(FV,sr_10mm);
% view(angles(1,1),angles(1,2));
% zoom(1.5);
% colormap(jet)
% 
% saveas(fig_1, ['../surfaceratio_pics/' specie '_' hemi '_5mm_10mm.jpg']);
% 
% fig_2 = figure(2);
% subplot(2,2,1);
% title('15mm');
% my_view_surface(FV,sr_15mm);
% zoom(1.0);
% subplot(2,2,2);
% my_view_surface(FV,sr_15mm);
% view(angles(1,1),angles(1,2));
% zoom(1.9);
% 
% subplot(2,2,3);
% title('20mm');
% my_view_surface(FV,sr_20mm);
% zoom(1.0);
% subplot(2,2,4);
% my_view_surface(FV,sr_20mm);
% view(angles(1,1),angles(1,2));
% zoom(1.5);
% colormap(jet);
% 
% saveas(fig_2, ['../surfaceratio_pics/' specie '_' hemi '_15mm_20mm.jpg']);

%% for one hemi
sr_5mm = read_curv(['../meshes_centered/' specie '/surfaceratio/' hemi '_5mm.curv']);
sr_10mm = read_curv(['../meshes_centered/' specie '/surfaceratio/' hemi '_10mm.curv']);
sr_15mm = read_curv(['../meshes_centered/' specie '/surfaceratio/' hemi '_15mm.curv']);
sr_20mm = read_curv(['../meshes_centered/' specie '/surfaceratio/' hemi '_20mm.curv']);

angles=[-100 10;129 -40];

fig_1 = figure(1);

subplot(2,2,1);
my_view_surface(FV,sr_5mm);
view(angles(1,1),angles(1,2));
zoom(1.6);
%title('5mm');

subplot(2,2,2);
my_view_surface(FV,sr_10mm);
view(angles(1,1),angles(1,2));
zoom(1.6);
%title('10mm');

subplot(2,2,3);
my_view_surface(FV,sr_15mm);
view(angles(1,1),angles(1,2));
zoom(1.6);
%title('15mm');

subplot(2,2,4);
my_view_surface(FV,sr_20mm);
view(angles(1,1),angles(1,2));
zoom(1.3);
%title('20mm');
colormap(jet)

saveas(fig_1, ['../surfaceratio_pics/' specie '_' hemi '_all.jpg']);


end

