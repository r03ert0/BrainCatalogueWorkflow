function [FV,A]=smooth_cortex(arg1,arg2,arg3,arg4)
%SMOOTH_CORTEX - Smoothes tesselation
% function [FV,A]=smooth_cortex(arg1,arg2,arg3,arg4)
%
% function [smoothedFV,A]=smooth_cortex(FV,vertConnFV,a,nIterations)
% FV is the tesselation to be smoothed
% vertConnFV is the vertices connectivity of the FV tesselation
% a is the smoothing constant
% nIterations is the number of iterations
%
% function [smoothedFV,A]=smooth_cortex(FV,A,nIterations)
% FV is the tesselation to be smoothed
% A is the sparse smoothing matrix used
% nIterations is the number of iterations
%
% smoothedFV returned is the smoothed tesselation
% A returned is the sparse smoothing matrix used
%
% Remarks: smooth_cortex implements the following expression
% smoothedFV.vertices(i,:)=FV.vertices(i,:)+a/N*sum(FV.vertices(neighbor_j,:)-FV.vertices(i,:))
% where FV.vertices(i,:) is the ith vertex, N is the number of neighbors of this vertex, a is a smoothing
% constant, FV.vertices(neighbor_j,:) is jth neighbor of ith vertex. Sum goes over all neighbors of ith
% vertex.
%
%See also VERTICES_CONNECTIVITY

%<autobegin> ---------------------- 27-Jun-2005 10:45:45 -----------------------
% ------ Automatically Generated Comments Block Using AUTO_COMMENTS_PRE7 -------
%
% CATEGORY: Visualization
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
%<autoend> ------------------------ 27-Jun-2005 10:45:45 -----------------------

% ------------------------------ Script Author ---------------------------------
% Dimitrios Pantazis, Ph.D.

% ----------------------------- Script History ---------------------------------
% 11-Apr-2002 DP  Creation
% 19-May-2004 JCM Fixing a "break" warning notice from Matlab, fixing comments
% ----------------------------- Script History ---------------------------------

%choose whether to display bars
if(~exist('VERBOSE','var')),
    VERBOSE = 1; % default non-silent running of waitbars
end

narg = nargin;
if narg==4
    %assign inputs
    FV=arg1;
    vertConnFV=arg2;
    a=arg3;
    nIterations=arg4;
    
    nVertices=size(FV.vertices,1);
    if(VERBOSE)
        hwait = waitbar(0,'Creating smoothing matrix...');
        drawnow %flush the display
        step=round(nVertices/10);
    end
    %calculate smoothing matrix
    A=sparse(nVertices,nVertices);
    for i=1:nVertices
        if(VERBOSE)
            if(~rem(i,step)) % ten updates
                waitbar(i/nVertices,hwait);
                drawnow %flush the display         
            end
        end
        A(i,i)=1-a;
        A(i,vertConnFV{i})=a/length(vertConnFV{i});
    end
    if(VERBOSE)
        close(hwait);
    end
elseif narg==3
    FV=arg1;
    A=arg2;
    nIterations=arg3;
    nVertices=size(FV.vertices,1);
else 
    disp('Incorrect number of inputs to "smooth_cortex" function'); FV=0; A=0;
    % break;
    % A BREAK statement appeared outside of a loop.  This statement is currently
    % treated as a RETURN statement, but future versions of MATLAB will error
    % instead.
    % JCM fix 19-M1y-2004
    return

end

if(VERBOSE)
    hwait = waitbar(0,'Applying smoothing...');
    drawnow %flush the display
    step=round(nIterations/1);
end
for i=1:nIterations
    if(VERBOSE)
        if(~rem(i,step)) % ten updates
            waitbar(i/nIterations,hwait);
            drawnow %flush the display         
        end
    end
    FV.vertices=A*FV.vertices;
end
if(VERBOSE)
    close(hwait);
end


