function func_out=vert2tri(FV,func_in)
% INPUTS: 
%   - FV: mesh with fields faces, vertices
%   - func_in: input function, defined on vertices or faces
%
% OUTPUTS:
%   - func_out: output function, defined on faces or vertices
%   (respectively)

%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

B=incidence_matrix(FV);
if size(func_in,1)==length(FV.vertices)
    B=B';
elseif size(func_in,1)==length(FV.faces)
else
    disp('func_in has not the good size');
    return;
end
connectivity=sum(B,2);

func_out=(B*func_in)./repmat(connectivity,1,size(func_in,2));
