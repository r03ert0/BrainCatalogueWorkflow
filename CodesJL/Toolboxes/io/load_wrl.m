function [vertex,faces_out]=load_wrl(fname)

disp(['Reading The File  ', fname])
vrfile=fopen(fname);
nb_mesh=0;
data=1;
while (data ~= -1)
    nb_mesh=nb_mesh+1
    counter=0;
    while counter~=-1
        data=fgets(vrfile);
        if data==-1
            break
        end
        fpoint=findstr(data,'translation');
        if ~isempty(fpoint)
            trans=sscanf(data(15:end),'%f',inf);
            counter=-1;
        end
    end
    counter=0;
    while counter~=-1
        data=fgets(vrfile);
        if data==-1
            break
        end
        fpoint=findstr(data,'scale');
        if ~isempty(fpoint)
            scale=sscanf(data(8:end),'%f',inf);
            counter=-1;
        end
    end
    p=1;counter=0;pointcloud=[0 0 0];
    while counter~=-1
        data=fgets(vrfile);
        if data==-1
            break
        end
        fpoint=findstr(data,'point');% 2 checkers to find out the begining
        f2point=findstr(data,'[');   %of the x,y,z " point [ "
        while ~isempty(fpoint) & ~isempty(f2point)
            data=fgets(vrfile);
            if data==-1
                break
            end
            t=sscanf(data,'%f %f %f,',inf);
            for j=0:(length(t)/3)-1;
                pointcloud(p,:)=t(3*j+1:3*(j+1))';
                p=p+1;
            end
            if ~isempty(findstr(data,']'))
                fpoint=[];counter=-1;
            end
        end
    end
    if data==-1
            break
    end
    pointcloud(:,1)=pointcloud(:,1)*scale(1)+trans(1);
    pointcloud(:,2)=pointcloud(:,2)*scale(2)+trans(2);
    pointcloud(:,3)=pointcloud(:,3)*scale(3)+trans(3);
    vertex{nb_mesh}=pointcloud;
    
    counter=0;t_full=[];
    while counter~=-1
        data=fgets(vrfile);
        if data==-1
                break
        end
        fpoint=findstr(data,'coordIndex');% 2 checkers to find out the begining
        f2point=findstr(data,'[');   %of the x,y,z " point [ "
        while ~isempty(fpoint) & ~isempty(f2point)
            data=fgets(vrfile);
            t=sscanf(data,'%f,',inf);
            t_full=[t_full;t];
            if ~isempty(findstr(data,']'));
                fpoint=[];counter=-1;
            end
        end
    end
    
    p=1;faces=[0 0 0];j=1;
    for i=1:length(t_full)
        if t_full(i)==-1
            p=p+1;
            j=1;
        else
            faces(p,j)=t_full(i);
            j=j+1;
        end
    end

%     fin=length(faces(1,:));
%     indices=find(faces(:,fin));
%     while mod(fin,3)==0 && ~isempty(indices) && fin>3
%         for i=1:length(indices)
%             faces(length(faces(:,1))+1,1:3)=faces(indices(i),end-2:end);
%         end
%         faces(:,end-2:end)=[];
%         fin=length(faces(1,:));
%         indices=find(faces(:,fin));
%     end
%    if data==-1
%            break
%    end
        faces(:,4:end)=[];
    faces_out{nb_mesh}=faces+1;
end
nb_mesh=nb_mesh-1;
coul=['b','r','y','c','k'];
i=1;
figure
hold on
for me=1:nb_mesh
    p1 =patch('vertices', vertex{me}, 'faces', faces_out{me}, 'FaceColor',coul(i));
    set(p1,'EdgeColor','none')
    %ve=vertex{me};
    %plot3(ve(:,1),ve(:,2),ve(:,3),['.',coul(i)])
    i=i+1;
    if i>length(coul)
        i=1;
    end
end
axis equal
axis image off;
colormap('gray');
view(-135,45);
rotate3d on
drawnow
camlight;
camlight(-80,-10);
lighting phong;
cameramenu;

fclose(vrfile); 