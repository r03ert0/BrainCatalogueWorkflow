function surfaceratio_pics(specie, hemi)
%function to save pics with surfaceratio with spheres of differet

% 
% 
% %addpath('/a/software/matlab/extensions/fieldtrip/currentversion/public/');
% addpath('../matlab/extensions/fieldtrip/currentversion/public/');
% addpath('../geodist_sulc-master/geodesic');
% addpath('../geodist_sulc-master/areal/share');
% addpath('../geodist_sulc-master/surfstat');
% 
% %read surface
% specie = 'slow_loris';
% hemi = 'both';
% 
% 
% [vert, faces] = read_ply(['meshes_centered/' specie '/' hemi '.ply']);
% vertices(:,1) = vert.x;
% vertices(:,2) = vert.y;
% vertices(:,3) = vert.z;
% surf.tri = faces;
% surf.coord = vertices';
% %x = size(vert.x);
% 
% %for both hemi--- problem with digit number -- doesn' work
% %sr_5mm = importdata(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_5mm.txt']);
% %sr_5mm = sr_5mm(:,1);
% %sr_10mm = importdata(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_10mm.txt']);
% %sr_10mm = sr_10mm(:,1);
% %sr_15mm = importdata(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_15mm.txt']);
% %sr_15mm = sr_15mm(:,1);
% %sr_20mm = importdata(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_20mm.txt']);
% %sr_20mm = sr_20mm(:,1);
% 
% 
% %sr_5mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '_5mm.curv']);
% %sr_10mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '_10mm.curv']);
% %sr_15mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '_15mm.curv']);
% %sr_20mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '_20mm.curv']);
% 
% sr_5mm = read_curv(['./meshes_centered/' specie '/surfaceratio/' hemi '.sratio_5mm.curv']);
% sr_10mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_10mm.curv']);
% 
% 
% figure(1)
% %subplot(2,2,1)
% SurfStatView(sr_5mm, surf);
% subplot(2,2,2)
% SurfStatView(sr_10mm, surf);
% subplot(2,2,3)
% SurfStatView(sr_15mm, surf);
% subplot(2,2,4)
% SurfStatView(sr_20mm, surf);
% 
% 
% srfwrite(vertices,faces,['meshes_centered/' specie '/surfaceratio/' hemi '.srf']);
% [vtx,fac] = srfread(['meshes_centered/' specie '/surfaceratio/' hemi '.srf']);
% dpxwrite(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_5mm.dpv'], sr_5mm, vtx, 1:length(vtx));
% dpx2map(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_5mm.dpv'], ['meshes_centered/' specie '/' hemi '.srf'], ['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_5mm'], 'jet');
% 
% dpxwrite(['../../surfaces/' species '/' hemi '_zones_all.dpv'], zones_all, vtx, 1:length(vtx));
% dpx2map(['../../surfaces/' species '/' hemi '_zones_all.dpv'], ['../../surfaces/' species '/' hemi '_all.srf'], ['../../surfaces/' species '/' hemi '_zones_all'], 'jet');
% % my_view_surface(FV,Vt(:,1))
% %         view(angles(1,1),angles(1,2))
% %         %zoom(2)
% 
% savefig([specie '.png'])



% Juliens
%first add paths
ToolboxFolder='/Users/ghfc/Documents/Dropbox/hugo_is_dead/scripts/BrainCatalogueWorkflow/CodesJL/Toolboxes/';
addpath(genpath(ToolboxFolder))
addpath('../geodist_sulc-master/surfstat');
addpath('CodesJL/')


[vertices,faces]=read_ply(['meshes_centered/' specie '/' hemi '.ply']);
FV.faces=faces;
FV.vertices=vertices;
sr_5mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_5mm.curv']);
sr_10mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_10mm.curv']);
sr_15mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_15mm.curv']);
sr_20mm = read_curv(['meshes_centered/' specie '/surfaceratio/' hemi '.sratio_20mm.curv']);


fig_1 = figure(1);

subplot(2,2,1)
title('5mm')
my_view_surface(FV,sr_5mm)
zoom(1.0)
subplot(2,2,2)
my_view_surface(FV,sr_5mm)
view(angles(1,1),angles(1,2))
zoom(1.9)

subplot(2,2,3)
title('10mm')
my_view_surface(FV,sr_10mm)
zoom(1.0)
subplot(2,2,4)
my_view_surface(FV,sr_10mm)
view(angles(1,1),angles(1,2))
zoom(1.5)
colormap(jet)

saveas(fig_1, ['surfaceratio_pics/' specie '_' hemi '_5mm_10mm.jpg']);

fig_2 = figure(2);
subplot(2,2,1)
title('15mm')
my_view_surface(FV,sr_15mm)
zoom(1.0)
subplot(2,2,2)
my_view_surface(FV,sr_15mm)
view(angles(1,1),angles(1,2))
zoom(1.9)

subplot(2,2,3)
title('20mm')
my_view_surface(FV,sr_20mm)
zoom(1.0)
subplot(2,2,4)
my_view_surface(FV,sr_20mm)
view(angles(1,1),angles(1,2))
zoom(1.5)
colormap(jet)

saveas(fig_2, ['surfaceratio_pics/' specie '_' hemi '_15mm_20mm.jpg']);


end

