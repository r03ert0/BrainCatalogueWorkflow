function [NFV,nX,nY,fff]=check_mesh2(faces,vertices,X,Y,f,area_orig,fff)
% Mesh refinement strategy
% Ref: J. Lefèvre, J.F. Mangin, A reaction-diffusion model of human brain
% development, PLoS Computational Biology
%
% 1) Find triangles where distorsion is important
% 2) Divide each triangle in four triangles by introducing middle points of
% each edge
% 3) Divide in two each of the three neighboring triangles
%
%/---Script Authors---------------------\
%|                                      |
%|   *** J.Lefèvre, PhD                 |
%|   julien.lefevre@univ-amu.fr         |
%|                                      |
%\--------------------------------------/

area_new=tri_area(faces,vertices);

% 1) Find triangles where distorsion is important
indices=find(area_new/area_orig>f);

NFV.faces=faces;
NFV.vertices=vertices;
ind=length(vertices)+1;
indT=length(faces)+1;
k=1;
nX=X;
nY=Y;
N=length(indices);
for ii=1:N
    if ii>length(indices)
        return
    end
    ind_ii=find(NFV.faces(:,1)==faces(indices(ii),1) & NFV.faces(:,2)==faces(indices(ii),2) &...
        NFV.faces(:,3)==faces(indices(ii),3)); 
    triangle=NFV.faces(ind_ii,:);
    try
        %2) Divide each triangle in four triangles by introducing middle points of
        % each edge
        
        A=triangle(1);
        B=triangle(2);
        C=triangle(3);
        
        % Middle of each edge
        AA=(vertices(B,:)+vertices(C,:))/2;
        BB=(vertices(A,:)+vertices(C,:))/2;
        CC=(vertices(B,:)+vertices(A,:))/2;
        NFV.vertices=[NFV.vertices;AA;BB;CC];
        new_trianglesABC=[ind C ind+1;ind+1 A ind+2;ind+2 B ind;ind ind+1 ind+2];
        
        [iiA,jj]=find(NFV.faces==A);
        [iiB,jj]=find(NFV.faces==B);
        [iiC,jj]=find(NFV.faces==C);
        
        % 3) Divide in two each of the three neighboring triangles
        
        tAb=setdiff(intersect(iiC,iiB),ind_ii); %triangles à couper
        tBb=setdiff(intersect(iiA,iiC),ind_ii);
        tCb=setdiff(intersect(iiA,iiB),ind_ii);
        
        iA= intersect(tAb,indices);
        if ~isempty(iA) % on peut rajouter un test sur les aires mais ça va faire lourd
            indices=setdiff(indices,iA);
        end
        iB= intersect(tBb,indices);
        if ~isempty(iB) % on peut rajouter un test sur les aires mais ça va faire lourd
            indices=setdiff(indices,iB);
        end
        iC= intersect(tCb,indices);
        if ~isempty(iC) % on peut rajouter un test sur les aires mais ça va faire lourd
            indices=setdiff(indices,iC);
        end
        ttAb=NFV.faces(tAb,:);
        ttBb=NFV.faces(tBb,:);
        ttCb=NFV.faces(tCb,:);
        Ab=setdiff(ttAb([1 2 3]),[B C]);
        Bb=setdiff(ttBb([1 2 3]),[A C]);
        Cb=setdiff(ttCb([1 2 3]),[B A]);
        
        ind_Ab=find(NFV.faces(:,1)==ttAb(1) & NFV.faces(:,2)==ttAb(2) &...
            NFV.faces(:,3)==ttAb(3));
        ind_Bb=find(NFV.faces(:,1)==ttBb(1) & NFV.faces(:,2)==ttBb(2) &...
            NFV.faces(:,3)==ttBb(3));
        ind_Cb=find(NFV.faces(:,1)==ttCb(1) & NFV.faces(:,2)==ttCb(2) &...
            NFV.faces(:,3)==ttCb(3));
        
        to_remove=[ind_ii ind_Ab ind_Bb ind_Cb];
        NFV.faces=[NFV.faces(setdiff(1:length(NFV.faces),unique(to_remove)),:) ;  new_trianglesABC ; ...
            Ab C ind;Ab ind B;Bb A ind+1;Bb ind+1 C;Cb B ind+2;Cb ind+2 A];
        
        nX(ind)=(X(B)+X(C))/2;
        nY(ind)=(Y(B)+Y(C))/2;
        nX(ind+1)=(X(A)+X(C))/2;
        nY(ind+1)=(Y(A)+Y(C))/2;
        nX(ind+2)=(X(B)+X(A))/2;
        nY(ind+2)=(Y(B)+Y(A))/2;
        
        fff=[fff(setdiff(1:length(fff),unique(to_remove))) ; repmat( fff(ind_ii)/16,4,1) ;...
            repmat(fff(ind_Ab)/4,2,1) ; repmat(fff(ind_Bb)/4,2,1) ;repmat(fff(ind_Cb)/4,2,1 ) ];
        ind=ind+3;
        indT=indT+6;
        k=k+1;
    catch
    end
end