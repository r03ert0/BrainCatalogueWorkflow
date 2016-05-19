 function [mixedRGB,currDensityColorMap] = blend_anatomy_data(Curvature,currDensity,varargin)
%BLEND_ANATOMY_DATA - (Curvature,currDensity,limitValue,currDensityTransparency,anatomyColor,currDensityColorMap)
%  function [mixedRGB,currDensityColorMap] = blend_anatomy_data(Curvature,currDensity,varargin)
 % Default Values
 default.currDensityTransparency = .2;    
 default.anatomyColor = [.2 .2 .2; .6 .6 .6];
 %currDensityColorMap
 color1 = hot(130);
 color2 = color1(:,[3 2 1]);
 tmp = flipud([flipud(color1);color2]);
 default.currDensityColorMap = tmp(40:240,:); 
 default.limitValue = NaN;

 
currDensityTransparency = default.currDensityTransparency;
anatomyColor = default.anatomyColor;
currDensityColorMap = default.currDensityColorMap;
limitValue = default.limitValue;

 
 if nargin == 2
     % default colormapping is 'normalized'
     limitValue = max(abs(currDensity));
 elseif nargin == 3
     limitValue = varargin{1};
 elseif nargin == 4
     limitValue = varargin{1};
     currDensityTransparency = varargin{2};
 elseif nargin == 5
     limitValue = varargin{1};
     currDensityTransparency = varargin{2};
     anatomyColor = varargin{3};
 elseif nargin == 6
     limitValue = varargin{1};
     currDensityTransparency = varargin{2};
     anatomyColor = varargin{3};
     currDensityColorMap = varargin{4};

%<autobegin> ---------------------- 27-Jun-2005 10:29:44 -----------------------
% --------- Automatically Generated Comments Block Using AUTO_COMMENTS ---------
%
% CATEGORY: Unknown Category
%
% Alphabetical list of external functions (non-Matlab):
%   toolbox\blend_anatomy_data.m  NOTE: Routine calls itself explicitly
%   toolbox\bst_message_window.m
%
% At Check-in: $Author: esen $  $Revision: 80 $  $Date: 2006-02-21 15:10:10 -0800 (Tue, 21 Feb 2006) $
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
%<autoend> ------------------------ 27-Jun-2005 10:29:44 -----------------------

 end
 
 if isempty(limitValue)
     limitValue = default.limitValue;
 end
 if isempty(currDensityTransparency)
     currDensityTransparency = default.currDensityTransparency;
 end
 if isempty(anatomyColor)
     anatomyColor = default.anatomyColor;
 end
 if isempty(currDensityColorMap)
     currDensityColorMap = default.currDensityColorMap;
 end
 
 if isnan(limitValue) % Assume normalize
     limitValue = max(abs(currDensity));
 end
 
 if size(anatomyColor,1) == 2
     anatColorMap = [anatomyColor(1,:);...
             zeros(size(currDensityColorMap,1)-2,3);...
             anatomyColor(2,:)]; % Anatomy colormap - articifical zero padding 
 elseif size(anatomyColor,1) > 2
     anatColorMap = anatomyColor;
 end
     
 % Translate anatomy curvature in RGB values
 min_curv = min(Curvature);
 max_curv = max(Curvature);
 if max_curv == min_curv % No curvature encoding
     index_anatomy = size(anatColorMap,1) * ones(size(Curvature));
 else
     index_anatomy = floor((Curvature-min_curv)*(size(currDensityColorMap,1)-1)/(max_curv-min_curv)+1);
 end
 
 anatRGB = anatColorMap(index_anatomy,:); clear index_anatomy
 
 
 % Now surface data 
 % Amplitude scaling
%  if isempty(currDensity) 
%      currDensity = zeros(length(Curvature),1);
%  else
%      currDensity = double(currDensity);
%      
%      switch limitValue % is color mapping time-relative or time-normalized ?
%          case 0 %'normalized'
%              if size(currDensity,2) == 1 %e.g Representation of  neural activity index
%                  if 0,%OPTIONS.Time >1
%                      bst_message_window('wrap',{'Currently visualized result does not change with time',' '});
%                  end
%                  
%                  currDensity = abs(currDensity(:,1))/max(abs(currDensity(:,1)));
%              else
%                  currDensity = abs(currDensity(:,OPTIONS.Time))/max(abs(currDensity(:,OPTIONS.Time)));
%              end
%              limitValue = max(currDensity); % Store maximum value 
%              
%          case 1
%              if size(currDensity,2) == 1 %e.g Representation of  neural activity index
%                  if 0,%OPTIONS.Time >1
%                      bst_message_window('wrap',{'Currently visualized result does not change with time',' '});
%                  end
%                  currDensity = abs(currDensity(:,1))/max(abs(currDensity(:)));
%                  
%              else
%                  currDensity = abs(currDensity(:,OPTIONS.Time))/max(abs(currDensity(:)));
%              end
%              limitValue = 1; % Force it to 1
%      end
%  end
% 
% if limitValue == min(currDensity) % no current value above threshold
%     limitValue = -1 ;
% end
% %clear tmpcurrDensity

%Temp. Solution, kj 08/12/2004
% Clip in relative display if values above limitValue:
if (max(abs(currDensity)) > limitValue),
    bst_message_window('wrap',...
        sprintf('Maximum data value is %3.2e, all values will be clipped at max limit value %3.2e for display',max(currDensity),limitValue));
    currDensity(currDensity > limitValue) = limitValue;%kj 08/12/2004
    bst_message_window('wrap',...
        sprintf('Minimum data value is %3.2e, all values will be clipped at min limit value %3.2e for display',min(currDensity),-limitValue));
    currDensity(currDensity < -limitValue) = -limitValue;
end

if limitValue~=0
    index_density = round( ((size(currDensityColorMap,1)-1)/(2*limitValue)) * currDensity + .5*(size(currDensityColorMap,1)+1) ); 
else
    index_density = [];
end


currDensityRGB = currDensityColorMap(index_density,:);

% Now mix curaveture and current RGBs
mixedRGB = anatRGB;
% Check if the resulting map is produced by unconstrained orientation
if length(currDensity) == 3*length(anatRGB)
    currDensity = reshape(currDensity, 3, length(currDensity)/3);
    currDensity = sum(currDensity.^2,1)';
end
toBlend = find(currDensity ~= 0); % Find vertex indices holding non-zero activation (after thresholding)
mixedRGB(toBlend,:) = currDensityTransparency*anatRGB(toBlend,:)+...
    (1-currDensityTransparency)*currDensityRGB(toBlend,:);

