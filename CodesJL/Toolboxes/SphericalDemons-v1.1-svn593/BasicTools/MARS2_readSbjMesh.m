% Contact ythomas@csail.mit.edu or msabuncu@csail.mit.edu for bugs or questions 
%
%=========================================================================
%
%  Copyright (c) 2008 Thomas Yeo and Mert Sabuncu
%  All rights reserved.
%
%Redistribution and use in source and binary forms, with or without
%modification, are permitted provided that the following conditions are met:
%
%    * Redistributions of source code must retain the above copyright notice,
%      this list of conditions and the following disclaimer.
%
%    * Redistributions in binary form must reproduce the above copyright notice,
%      this list of conditions and the following disclaimer in the documentation
%      and/or other materials provided with the distribution.
%
%    * Neither the names of the copyright holders nor the names of future
%      contributors may be used to endorse or promote products derived from this
%      software without specific prior written permission.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
%ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
%WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
%ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
%(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
%LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
%ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
%SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    
%
%=========================================================================
function MARS_sbjMesh = MARS2_readSbjMesh(params)

% params:
% {SUBJECTS_DIR, SUBJECT, surf_filename, metric_surf_filename, 
% annot_filename, data_filename_cell, unfoldBool, structures_of_interest,
% normalizeBool, hemi, radius}

%This function read in a surface specified by surf_filename found in the
%SUBJECTS_DIR/SUBJECT/surf directory, as well as the annotation by
%annot_filename found in the SUBJECTS_DIR/SUBJECT/label directory and
%finally the data specified by the data_filename_cell assumed to be in the
%SUBJECTS_DIR/SUBJECT/label directory.
%function also reads in surface for which metric distortion is calculated
%specified by metric_surf_filename
%
%Assume normalization at 100.

if(~isfield(params, 'radius'))
    radius = 100;
else
    radius = params.radius;
end


total_surface_area = 4*pi*radius^2;

% Read surface specified by user
if(isfield(params, 'hemi'))
    [vertices, faces] = read_surf([params.SUBJECTS_DIR '/' params.SUBJECT '/surf/' params.hemi '.' params.surf_filename]);
else
    [vertices, faces] = read_surf([params.SUBJECTS_DIR '/' params.SUBJECT '/surf/' params.surf_filename]);
end

%Reverse direction of faces!!! so as to be in line with icosahedronMesh
if (isfield(params, 'flipFacesBool'))
    if(params.flipFacesBool)
        faces = [faces(:,3) faces(:,2) faces(:,1)];
    end
end

vertices = single(vertices);
faces = int32(faces+1);

LengthVec = sqrt(sum(vertices.^2, 2));
vertices = vertices./repmat(LengthVec, 1, 3) * radius; %normalizes surface area to that specified by radius

% Read the surface used to calculate metric distortion

if (isfield(params, 'metric_surf_filename'))
    if(isfield(params, 'hemi'))
        [metricVerts, ignored] = read_surf([params.SUBJECTS_DIR '/' params.SUBJECT '/surf/' params.hemi '.' params.metric_surf_filename]);
    else
        [metricVerts, ignored] = read_surf([params.SUBJECTS_DIR '/' params.SUBJECT '/surf/' params.metric_surf_filename]);
    end
    metricVerts = single(metricVerts);
    %normalize surface area to be the same.
    metricSurfaceArea = MARS_calculateSurfaceArea(metricVerts, faces);
    surface_scaling_factor = sqrt(total_surface_area/metricSurfaceArea);
    metricVerts = metricVerts*surface_scaling_factor;
else
    surface_scaling_factor = [];
    metricVerts = [];
end


%Read data
if (isfield(params, 'data_filename_cell'))
    num_data = length(params.data_filename_cell);
    data = zeros(length(vertices), num_data, 'single');

    normalization = zeros(num_data, 1);
    for i = 1:num_data
        if(isfield(params, 'hemi'))
            data(:,i) = single(read_curv([params.SUBJECTS_DIR '/' params.SUBJECT '/surf/' params.hemi '.' params.data_filename_cell{i}]));
        else
            data(:,i) = single(read_curv([params.SUBJECTS_DIR '/' params.SUBJECT '/surf/' params.data_filename_cell{i}]));
        end
        if(isfield(params, 'normalizeBool'))
            if(params.normalizeBool == 1)
                data(:,i) = data(:,i)-median(data(:,i));
                data(:,i) = data(:,i)/std(data(:,i));
                
                index = find(data(:, i) < -3);
                data(index, i) = -3 - (1 - exp(3 - abs(data(index, i))));
                index = find(data(:, i) > 3);
                data(index, i) = 3 + (1 - exp(3 - abs(data(index, i))));
                
                data(:,i) = data(:,i)/std(data(:,i));
                index = find(data(:, i) < -3);
                data(index, i) = -3 - (1 - exp(3 - abs(data(index, i))));
                index = find(data(:, i) > 3);
                data(index, i) = 3 + (1 - exp(3 - abs(data(index, i))));
            elseif(params.normalizeBool == 2)   
                
                %max normalization
                BIG_NO = -1e6;
                if(data(1, i) ~= BIG_NO)
                    normalization(i) = max(data(:,i));
                    data(:, i) = data(:, i)/normalization(i);
                end
                
            else
                clear normalization;%do nothing
            end
        end
    end
else
    data = [];
end

%Find vertexFaces
vertexFaces =  MARS_convertFaces2FacesOfVert(faces, int32(size(vertices, 1)));
num_per_vertex = length(vertexFaces)/size(vertices,1);
vertexFaces = reshape(vertexFaces, size(vertices,1), num_per_vertex);

% Compute Face Areas.
faceAreas = MARS_computeMeshFaceAreas(int32(size(faces, 1)), int32(faces'), single(vertices'));  

%Find vertexNbors
vertexNbors = MARS_convertFaces2VertNbors(faces, int32(size(vertices,1)));
num_per_vertex = length(vertexNbors)/size(vertices,1);
vertexNbors = reshape(vertexNbors, size(vertices,1), num_per_vertex);

%Read brain labels
if (isfield(params, 'annot_filename'))
    if(isfield(params, 'hemi'))
        [ignored, MARS_label, MARS_ct] = read_annotation([params.SUBJECTS_DIR '/' params.SUBJECT '/label/' params.hemi '.' params.annot_filename]);
    else
        [ignored, MARS_label, MARS_ct] = read_annotation([params.SUBJECTS_DIR '/' params.SUBJECT '/label/' params.annot_filename]);
    end

    if (isfield(params, 'structures_of_interest'))
        MARS_ct = MARS_reorganizeCT(MARS_ct, params.structures_of_interest);
        
    end
    [MARS_label, MARS_ct] = MARS_reorganizeLabels(MARS_label, MARS_ct, vertexNbors');
else
    MARS_label = [];
    MARS_ct = [];    
end

%Find vertexDistSq2Nbors
vertexDistSq2Nbors = MARS_computeVertexDistSq2Nbors(int32(size(vertexNbors', 1)), int32(size(vertices', 2)), int32(vertexNbors'), single(vertices'));

% Note the transpose!!!!!
MARS_sbjMesh = struct('vertices', vertices', 'metricVerts', metricVerts', 'faces', faces', 'vertexNbors', vertexNbors', 'vertexFaces', vertexFaces', 'vertexDistSq2Nbors', vertexDistSq2Nbors, ...
    'faceAreas', faceAreas', 'data', data', 'MARS_label', MARS_label', 'MARS_ct', MARS_ct, 'surface_scaling_factor', surface_scaling_factor);
if (isfield(params, 'unfoldBool'))
    if(params.unfoldBool)        
        if (isfield(params, 'flipFacesBool'))
            MARS_sbjMesh = MARS_simpleUnfoldMesh(MARS_sbjMesh, ~params.flipFacesBool);
        else
            MARS_sbjMesh = MARS_simpleUnfoldMesh(MARS_sbjMesh, 1);
        end
    end
end

% if(exist('normalization', 'var'))
%    MARS_sbjMesh.normalization = normalization; 
% end


