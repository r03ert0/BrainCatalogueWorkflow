function [fold]=fold_quantification_toro(FV,r)
% Computes Gyrification index as defined in Toro et al, 2008
% Follows the same implementation as in http://brainfolding.sourceforge.net/surfaceratio.html
%
% INPUTS
% - FV: mesh (fields .vertices and .faces)
% - r: radius
%
% OUTPUTS
% - fold: gyrification index at each vertex
%
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

avol=zeros(256,256,256);
%[A2,G,grad_v,aires,index1,index2,cont_vv]=heat_matrices(FV.faces,FV.vertices,3,1);
aires=tri_area(FV.faces,FV.vertices);

FV.vertices(:,1)=FV.vertices(:,1)-min(FV.vertices(:,1))+1;
FV.vertices(:,2)=FV.vertices(:,2)-min(FV.vertices(:,2))+1;
FV.vertices(:,3)=FV.vertices(:,3)-min(FV.vertices(:,3))+1;

for ii=1:size(FV.faces,1)
   for j=1:3
       x=floor(FV.vertices(FV.faces(ii,j),1));
       y=floor(FV.vertices(FV.faces(ii,j),2));
       z=floor(FV.vertices(FV.faces(ii,j),3));
       if(x>=1&&x<=256 && y>=0&&y<=256 && z>=0&&z<=256)
				avol(x,y,z)=avol(x,y,z)+aires(ii);
       end
   end
end

for ii=1:size(FV.vertices,1)
   asum=0;
   for x=-r:r
       for y=-r:r
           for z=-r:r
                if(x^2+y^2+z^2<r^2)
                    a=floor(FV.vertices(ii,1))+x;
                    b=floor(FV.vertices(ii,2))+y;
                    c=floor(FV.vertices(ii,3))+z;
                    if(a>=1&&a<=256 && b>=1&&b<=256 && c>=1&&c<=256)
                        asum=asum+avol(a,b,c);
                    end
                end
           end
       end
   end
   fold(ii)=asum/(pi*r^2)/3;
end