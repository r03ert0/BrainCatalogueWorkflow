function [a,b,grad_TH,grad_PHI,TH,PHI]=vector2tangent_plane(sphFV,FV,V,R,normalization)
% Decomposition of a vector field in a particular basis of the tangent
% plane, obtained thanks to a global spherical parameterization
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr    |
%|                                      | 
%\--------------------------------------/

% Spherical parameterization

tmp_coord=sphFV.vertices*R';
[TH,PHI] = cart2sph(tmp_coord(:,1),tmp_coord(:,2),tmp_coord(:,3));

% Local basis
grad_TH=scalar_field_gradient(TH,FV); % Be careful with 2pi periodicity for the gradient
grad_PHI=scalar_field_gradient(PHI,FV);
if normalization
    grad_TH=grad_TH./repmat(sqrt(sum(grad_TH.^2,2)),1,3);
    grad_PHI=grad_PHI./repmat(sqrt(sum(grad_PHI.^2,2)),1,3);
end

x=V(:,1).*grad_PHI(:,1)+V(:,2).*grad_PHI(:,2)+V(:,3).*grad_PHI(:,3);
y=V(:,1).*grad_TH(:,1)+V(:,2).*grad_TH(:,2)+V(:,3).*grad_TH(:,3);

detg=sum(grad_PHI.^2,2).*sum(grad_TH.^2,2)-sum(grad_PHI.*grad_TH,2).^2;
a=(sum(grad_PHI.^2,2).*y- sum(grad_PHI.*grad_TH,2).*x)./detg; 
b=(sum(grad_TH.^2,2).*x- sum(grad_PHI.*grad_TH,2).*y)./detg; 
