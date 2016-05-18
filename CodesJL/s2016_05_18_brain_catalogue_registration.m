%---------------------------------------------------------------%
%                                                               %
%               Curvatures on ferret data                       %
%                                                               %
%                       2016/04/10                              %
%---------------------------------------------------------------%

% Toolboxes
ToolboxFolder='/Users/julienlefevre/Documents/Recherche/MCF Marseille/Codes/Toolboxes/';
addpath(genpath(ToolboxFolder))

% Data
DataFolder='/Users/julienlefevre/Documents/Recherche/MCF Marseille/Data/BrainCatalogueWorkflow/meshes_centered/';


%-----------------------
% Left hemi
%-----------------------

specy='orangutan';
[vertices,faces]=read_ply([DataFolder,specy,'/','both.ply']);
FV.faces=faces;
FV.vertices=vertices;

% Spherical Parameterization
[sphFV,V]=map2sphere(FV,[1 2 3],0);

% Full Vizu

angles=[-100 10;90 0];
content=dir(DataFolder);
figure(1)
figure(2)

cpt=1;
for ii=1:length(content)
    if content(ii).name=='.'
    else
        [vertices,faces]=read_ply([DataFolder,content(ii).name,'/','left.ply']);
        FV.faces=faces;
        FV.vertices=vertices;

        % Spherical Parameterization
        [sphFV,V]=map2sphere(FV,[1 3 2],0);
    
        figure(1)
        subplot(3,3,cpt)
        my_view_surface(FV,V(:,end-1))
        view(angles(1,1),angles(1,2))
        zoom(2)
        
        
        figure(2)
        subplot(3,3,cpt)
        my_view_surface(sphFV,V(:,end-3))
        view(angles(2,1),angles(2,2))
        zoom(1.6)

        
        cpt=cpt+1;
    end
        
end

%---------------------
% Entire brain
%-----------------------

specy='orangutan';
[vertices,faces]=read_ply([DataFolder,specy,'/','both.ply']);
FV.faces=faces;
FV.vertices=vertices;

% Spherical Parameterization
[A2,G,~,aires]=heat_matrices(FV.faces,FV.vertices,3,1);
[V,D]=eigs(A2,G,5,'sm');
sphFV=map2sphere(FV,[1 2 3],0,V(:,[1 3 4]));


% Full Vizu

angles=[-100 10;129 -40];
content=dir(DataFolder);
figure(1)
figure(2)

cpt=1;
for ii=1:length(content)
    if content(ii).name=='.'
    else
        [vertices,faces]=read_ply([DataFolder,content(ii).name,'/','both.ply']);
        FV.faces=faces;
        FV.vertices=vertices;

        % Spherical Parameterization
        [A2,G,~,aires]=heat_matrices(FV.faces,FV.vertices,3,1);
        [V,D]=eigs(A2,G,5,'sm');
        if isequal(content(ii).name,'slow_loris')
            [sphFV,Vt]=map2sphere(FV,[3 2 1],0,V(:,[2 3 4]));
        else
            [sphFV,Vt]=map2sphere(FV,[3 2 1],0,V(:,[1 3 4]));
        end
        
        % curvature
        VertConn=vertices_connectivity(FV);
        curvature=curvature_cortex(FV,VertConn,1,0);

        figure(1)
        subplot(3,3,cpt)
        my_view_surface(FV,Vt(:,1))
        view(angles(1,1),angles(1,2))
        zoom(2)
               
        figure(2)
        subplot(3,3,cpt)
        my_view_surface(sphFV,-curvature)
        %my_view_surface(sphFV,allSI{cpt})
        view(angles(2,1),angles(2,2))
        zoom(1.6)

        
        cpt=cpt+1;
    end
        
end

%----------------------------------------
% Surface Ratio/Curvedness & Shape Index
%----------------------------------------

cpt=1;
Ns=9;
%GIs=cell(Ns,1);
allC=cell(Ns,1);
allSI=cell(Ns,1);
volumes=zeros(Ns,1);
areas=zeros(Ns,1);
for ii=1:length(content)
    if content(ii).name=='.'
    else
        [vertices,faces]=read_ply([DataFolder,content(ii).name,'/','both.ply']);
        FV.faces=faces;
        FV.vertices=vertices;
        tic
        vertConn=vertices_connectivity(FV);
        [curvatures,check_normalization]=principal_curvature(FV,vertConn);
        toc
        [allC{cpt},allSI{cpt},stats(:,cpt)]=curvedness_shape(curvatures,1);
        %GIs{cpt}=fold_quantification_toro(FV,8);
        volumes(cpt)=surface_volume(FV);
        aires=tri_area(FV.faces,FV.vertices);
        areas(cpt)=sum(aires);
        cpt=cpt+1;
    end
end

figure
plot(volumes,areas,'+') 
for ii=1:Ns   
    ind=findstr('_',content(ii+2).name);
    if isempty(ind)
        text(volumes(ii),areas(ii),content(ii+2).name)
    else
        text(volumes(ii),areas(ii),content(ii+2).name(ind+1:end))
    end
end
xlabel('Volume')
ylabel('Surface')


%--------------------------
% Pointwise correspondence
%--------------------------

FV_template=sphere_tri('ico',5,1);
Nv_t=length(FV_template.vertices);
resampled_surfaces=zeros(Nv_t,Ns,3);
resampledC_SI=zeros(Nv_t,Ns,2);

for cpt=1:Ns 
    [vertices,faces]=read_ply([DataFolder,content(cpt+2).name,'/','both.ply']);
    FV.faces=faces;
    FV.vertices=vertices;
    
    % Spherical Parameterization (redundant computation but it is fast)
    [A2,G,~,aires]=heat_matrices(FV.faces,FV.vertices,3,1);
    [V,D]=eigs(A2,G,5,'sm');
    if isequal(content(cpt+2).name,'slow_loris')
        [sphFV,Vt]=map2sphere(FV,[3 2 1],0,V(:,[2 3 4]));
    else
        [sphFV,Vt]=map2sphere(FV,[3 2 1],0,V(:,[1 3 4]));
    end
    
    % Interpolation
    tex_out=tex_to_mesh_SD(FV_template.vertices,sphFV,[allC{cpt},allSI{cpt},FV.vertices]); 
    resampledC_SI(:,cpt,1)=tex_out(:,1);
    resampledC_SI(:,cpt,2)=tex_out(:,2);
    resampled_surfaces(:,cpt,1)=tex_out(:,3);
    resampled_surfaces(:,cpt,2)=tex_out(:,4);
    resampled_surfaces(:,cpt,3)=tex_out(:,5);
end

% Just for fun
average_surface=FV_template;
average_surface.vertices=reshape(mean(resampled_surfaces,2),Nv_t,3);

% Average C and SI
average_C_SI=reshape(mean(resampledC_SI,2),Nv_t,2);

% Vizu
figure
subplot(1,2,1)
my_view_surface(average_surface,average_C_SI(:,2))
subplot(1,2,2)
my_view_surface(average_surface,average_C_SI(:,2))
