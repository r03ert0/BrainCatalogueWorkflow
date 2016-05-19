function FV = load_mesh(filename)

if nargin==0
    [f, pathname] = uigetfile({'*.mesh';'*.gii'},'Pick a file');
    filename = [pathname,f];
end
[pathstr, name, format] = fileparts(filename);

if ismember(lower(format),{'.mesh'})
    [vertex, faces, normal, vertex_number, faces_number] = load_BV_mesh(filename);
    nb_mesh = length(vertex);
    if nb_mesh>1
        FV = cell(1,nb_mesh);
        for m=1:nb_mesh
            FV{m}.vertices=vertex{m};
            FV{m}.faces=faces{m}+1;
  %          FV{m}.vertices(:,3)=-FV{m}.vertices(:,3);
        end
    else
        FV.vertices=vertex{1};
        FV.faces=faces{1}+1;
   %     FV.vertices(:,3)=-FV.vertices(:,3);
    end
else
    if ismember(lower(format),{'.gii'})
    g=gifti(filename);
    FV.faces=double(g.faces);
    FV.vertices=double(g.vertices);
    else
        error(sprintf('[load_mesh] Unknown format %s.',format));
    end
end