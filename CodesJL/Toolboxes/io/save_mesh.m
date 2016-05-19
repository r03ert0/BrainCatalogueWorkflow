function save_mesh(filename,FV,file_format)

error(nargchk(2,3,nargin));

[pathstr, name, ext] = fileparts(filename);
if ismember(lower(ext),{'.mesh'})
    if nargin == 2
        file_format = 'binar';
    else
        file_format = lower(file_format);
    end
    if iscell(FV)
        nb_mesh = length(FV);
        vertex = cell(1,nb_mesh);
		normals = cell(1,nb_mesh);
		faces = cell(1,nb_mesh);
        for m=1:nb_mesh
%            FV{m}.vertices(:,3)=-FV{m}.vertices(:,3);
            vertex{m}=FV{m}.vertices;
            faces{m}=FV{m}.faces-1;
            if size(faces{m},2)<3
                normals{m}=zeros(size(vertex{m},1),3);
            else
                normals{m} = mesh_normals(vertex{m}',FV{m}.faces');
            end
        end
    else
 %       FV.vertices(:,3)=-FV.vertices(:,3);
        vertex{1}=FV.vertices;
        faces{1}=FV.faces-1;
        if size(faces{1},2)<3
            normals{1}=zeros(size(vertex{1},1),3);
        else
            [~,normalVs]=mesh_normals(FV.vertices,FV.faces);
            normals{1} = normalVs;
        end
    end
    save_BV_mesh(filename,vertex,faces,normals,file_format)
else
    if ismember(lower(ext),{'.gii'})
        if nargin == 2
            file_format = 'Base64Binary';
        end
        g=gifti(FV);
        save(g,filename,file_format);
    else
        error(sprintf('[save_mesh] Unknown format %s.',ext));
    end
end
