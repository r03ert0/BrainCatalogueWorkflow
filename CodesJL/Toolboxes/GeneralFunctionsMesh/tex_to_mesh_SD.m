function tex_out=tex_to_mesh_SD(FV_template_vertices,FV_sphere,tex_in)
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** G.Auzias, PhD                  |  
%|   guillaume.auzias@gmail.com         |
%|                                      | 
%\--------------------------------------/

n=sqrt(sum(FV_sphere.vertices.*FV_sphere.vertices,2));
FV_sphere.vertices=FV_sphere.vertices./repmat(n,1,3);

n_tmpl=sqrt(sum(FV_template_vertices.*FV_template_vertices,2));
FV_template_vertices=FV_template_vertices./repmat(n_tmpl,1,3);


FV_sphere.vertices = single(100*FV_sphere.vertices);
FV_sphere.faces=int32(FV_sphere.faces);

vertexFaces =  MARS_convertFaces2FacesOfVert( FV_sphere.faces, int32(size(FV_sphere.vertices, 1)));
num_per_vertex = length(vertexFaces)/size(FV_sphere.vertices,1);
vertexFaces = reshape(vertexFaces, size(FV_sphere.vertices,1), num_per_vertex);

% Compute Face Areas.
faceAreas = MARS_computeMeshFaceAreas(int32(size(FV_sphere.faces, 1)), FV_sphere.faces', FV_sphere.vertices');  

%Find vertexNbors
vertexNbors = MARS_convertFaces2VertNbors(FV_sphere.faces, int32(size(FV_sphere.vertices,1)));
num_per_vertex = length(vertexNbors)/size(FV_sphere.vertices,1);
vertexNbors = reshape(vertexNbors, size(FV_sphere.vertices,1), num_per_vertex);
 
vertexDistSq2Nbors = MARS_computeVertexDistSq2Nbors(int32(size(vertexNbors', 1)), int32(size(FV_sphere.vertices', 2)), int32(vertexNbors'), FV_sphere.vertices');

surface_scaling_factor = [];
metricVerts = [];
data = [];
 MARS_label = [];
    MARS_ct = [];    
    
MARS_sbjMesh = struct('vertices', FV_sphere.vertices', 'metricVerts', metricVerts', 'faces', FV_sphere.faces', 'vertexNbors', vertexNbors', 'vertexFaces', vertexFaces', 'vertexDistSq2Nbors', vertexDistSq2Nbors, ...
    'faceAreas', faceAreas', 'data', data', 'MARS_label', MARS_label', 'MARS_ct', MARS_ct, 'surface_scaling_factor', surface_scaling_factor);

tex_out = MARS_linearInterpolate(single(100*FV_template_vertices'), MARS_sbjMesh , single(tex_in'));

tex_out=tex_out';