function varargout = view_surface(figname,faces,verts,cdata);
%VIEW_SURFACE - Convenient function to consistently plot surfaces
% function varargout = view_surface(figname,faces,verts,cdata);
% function [hf,hs,hl] = view_surface(figname,faces,verts,cdata);
% function [hf,hs,hl,dataColormap] = view_surface(figname,faces,verts,cdata);
% figname is the name of the figure window
% faces is the triangle listing
%       - if faces is a cell array, verts needs to be a cell array of same length
%         alpha transparency is used to visualize the multiple surfaces.
%         Order in array goes from inner to outer surface.
% verts are the corresponding vertices
%       - verts is either an array or a cell array
%       
% cdata is the colordata to use.  If not given, uses random face color
%       - if cdata is a cell array, use on cell per surface for color coding
% hf is the figure handle used
% hs is the handles to the surfaces
% hl is the handles to the lighting
% dataColormap is the colormap used to plot cdata values on the surface (see also: BLEND_ANATOMY_DATA)

%<autobegin> ---------------------- 27-Jun-2005 10:46:03 -----------------------
% ------ Automatically Generated Comments Block Using AUTO_COMMENTS_PRE7 -------
%
% CATEGORY: Visualization
%
% Alphabetical list of external functions (non-Matlab):
%   toolbox\blend_anatomy_data.m
%   toolbox\windclf.m
%   toolbox\windfind.m
%
% At Check-in: $Author: mosher $  $Revision: 20 $  $Date: 2006-02-10 18:03:10 -0800 (Fri, 10 Feb 2006) $
%
% This software is part of BrainStorm Toolbox Version 27-June-2005  
% 
% Principal Investigators and Developers:
% ** Richard M. Leahy, PhD, Signal & Image Processing Institute,
%    University of Southern California, Los Angeles, CA
% ** John C. Mosher, PhD, Biophysics Group,
%    Los Alamos National Laboratory, Los Alamos, NM
% ** Sylvain Baillet, PhD, Cognitive Neuroscience & Brain Imaging Laboratory,
%    CNRS, Hopital de la Salpetriere, Paris, France
% 
% See BrainStorm website at http://neuroimage.usc.edu for further information.
% 
% Copyright (c) 2005 BrainStorm by the University of Southern California
% This software distributed  under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPL
% license can be found at http://www.gnu.org/copyleft/gpl.html .
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%<autoend> ------------------------ 27-Jun-2005 10:46:03 -----------------------

% /---Script Authors-------------------------------------\
% |                                                      |
% |  *** John C. Mosher, Ph.D.                           |
% |  Biophysics Group                                    |
% |  Los Alamos National Laboratory                      |
% |  Los Alamos, New Mexico, USA                         |
% |  mosher@lanl.gov                                     |
% |                                                      |
% |  *** Sylvain Baillet, Ph.D.                          |
% |  Cognitive Neuroscience & Brain Imaging Laboratory   |
% |  CNRS UPR640 - LENA                                  | 
% |  Hopital de la Salpetriere, Paris, France            |
% |  sylvain.baillet@chups.jussieu.fr                    |
% |                                                      |
% \------------------------------------------------------/

% Script History ----------------------------------------------------------------------------------------
%
% SB  10-Mar-2003 : faces  and verts input arguments can now be cell arrays thereby yielding 3D plots 
%                   using alpha transparency for each surface
% SB  03-Jun-2003 : changed axis management and default view point in 3D
% JCM 19-Aug-2003 : updated comments to explain outputs
% SB  21-Oct-2003 : Basic lightning is 'none'
% JCM 11-May-2004 : reset lighting to shiny, CBB would be an external switch
% SB  18-Nov-2004 : Changed light locations, intensity
%                   Changed surface material properties
%                   Changed default viewpoint
%                   Force openGL viewing for better performances 
% --------------------------------------------------------------------------------------------------------

if iscell(faces) % Multiple plots requested on same figure window
    if length(faces) ~= length(verts) % sanity check
        errordlg('Faces and Vertices need to be cell arrays of same length', mfilename);
        return
    end
else
    faces = {faces};
    verts = {verts};
    if nargin > 3
        cdata = {cdata};
    end
    
end

if nargin == 4
    if ~iscell(cdata)
        cdata = {cdata};
    end
end

for k=1:length(faces) % For each requested surface
    
    if(size(verts{k},2) > 3), % assume transposed
        verts{k} = verts{k}';  % if the assumption is wrong, will crash below anyway
    end
    
    h = windfind(figname);
    
    if nargin == 3 
        Copper = get(h,'colormap');%copper(length(faces)+1);
        iColor = round(linspace(1,size(Copper,1),length(faces))); 
        cdata{k} = repmat(Copper(iColor(k),:),size(verts{k},1),1);
    elseif nargin == 4
        [cdata{k},dataColormap] = blend_anatomy_data(ones(size(verts{k},1),1),cdata{k},NaN,0);
        varargout{4} = dataColormap;
        set(h,'Colormap',dataColormap)
    end
    
    figure(h)
    if isempty(h)
        windclf
        hold on
    end
    
    hs(k) = patch('faces',faces{k},'vertices',verts{k},...
        'facevertexcdata',cdata{k},'facecolor','interp','edgecolor','none',...
        'backfacelighting','lit');
    
    if length(faces)>1
        set(hs(k),'FaceAlpha',k/length(faces));
    end
    
    axis vis3d
    axis equal 
    axis off

    switch 'custom'
        case 'custom'
            material([ 0.00 0.50 0.20 2.00 1.00 ])
            lighting phong
        case 'dull'
            material dull
            lighting phong
        case 'shiny'
            material shiny
            lighting phong
    end
    
    hl = [];
    if k ==1 & isempty(findobj(h,'type','light')) % avoid accumulating too many light objects in same window
        hl(1) = camlight(0,40,'infinite');
        hl(2) = camlight(180,40,'infinite');
        hl(3) = camlight(0,-90,'infinite');
        hl(4) = camlight(90,0,'infinite');
        hl(4) = camlight(-90,0,'infinite');
        
        for i = 1:length(hl),
            set(hl(i),'color',.9*[1 1 1]); % mute the intensity of the lights
        end
    end
    %     
    if(nargout>0),
        hf = h;  % only if the user has output argument
        varargout{1} = hf;
        varargout{2} = hs;
        varargout{3} = hl;
    end
    
end

set(gcf,'Renderer','openGL')
