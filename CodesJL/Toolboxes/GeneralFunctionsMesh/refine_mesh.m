function [NFV,nX,nY,fff]=refine_mesh(faces,vertices,X,Y,f,area_orig,fff)

area_new=tri_area(faces,vertices);
indices=find(area_new/area_orig>f); % compare areas

NFV.faces=faces;
NFV.vertices=vertices;
ind=length(vertices)+1;
indT=length(faces)+1;
k=1;
nX=X;
nY=Y;
while (~isempty(indices))

        ind_ii=indices(1);
        triangle=NFV.faces(ind_ii,:);
        A=triangle(1);
        B=triangle(2);
        C=triangle(3);
        
        % Angles
        AB=vertices(B,:)-vertices(A,:);
        AC=vertices(C,:)-vertices(A,:);
        BC=vertices(C,:)-vertices(B,:);
        aA=acos(AB*AC'/(norm(AB)*norm(AC)));
        aB=acos(-AB*BC'/(norm(AB)*norm(BC)));
        aC=acos(AC*BC'/(norm(AC)*norm(BC)));
        angles=[aA,aB,aC];
        
        % Test : triangle sharp/obtuse
        if max(angles)<=pi/2
            gravG=mean(vertices(triangle,:),1);
            
            [iiA,jj]=find(NFV.faces==A);
            [iiB,jj]=find(NFV.faces==B);
            nT2=setdiff(intersect(iiA,iiB),ind_ii);
            if isempty(nT2) % bord par exemple
                toremove1=[];
            else
                Cb=setdiff(NFV.faces(nT2,:),[A B]);
                [NFV,toremove1]=relaxation(gravG,A,B,Cb,ind_ii,nT2,NFV,ind);
            end
            
            [iiC,jj]=find(NFV.faces==C);
            [iiB,jj]=find(NFV.faces==B);
            nT3=setdiff(intersect(iiC,iiB),ind_ii);
            if isempty(nT3) % bord par exemple
                toremove2=[];
            else
                Ab=setdiff(NFV.faces(nT3,:),[C B]);
                [NFV,toremove2]=relaxation(gravG,B,C,Ab,ind_ii,nT3,NFV,ind);
            end
            
            [iiA,jj]=find(NFV.faces==A);
            [iiC,jj]=find(NFV.faces==C);
            nT4=setdiff(intersect(iiA,iiC),ind_ii);
            if isempty(nT4) % bord par exemple
                toremove3=[];
            else
                Bb=setdiff(NFV.faces(nT4,:),[A C]);
                [NFV,toremove3]=relaxation(gravG,C,A,Bb,ind_ii,nT4,NFV,ind);
            end
            
            toremove=unique([toremove1 toremove2 toremove3]);
            NFV.vertices=[NFV.vertices;gravG];
            NFV.faces=[NFV.faces(setdiff(1:length(NFV.faces),toremove),:)];
            nX(ind)=(X(A)+X(B)+X(C))/3;
            nY(ind)=(Y(A)+Y(B)+Y(C))/3;
            indices=setdiff(indices,toremove);
            indices=calcul_indices(indices,toremove);
            ind=ind+1;
        else
            [v,inda]=max(angles);
            comp_inda=setdiff([1 2 3],inda);
            %midG=mean(vertices(triangle(comp_inda,:),:),1);
            
            
        end
        
% %         fff(indT)=fff(indices(ii))/16;
% %         fff(indT+1)=fff(indices(ii))/16;
% %         fff(indT+2)=fff(indices(ii))/16;
% %         fff(indT+3)=fff(indices(ii))/16;
%         fff=[fff(setdiff(1:length(fff),unique(to_remove))) ; repmat( fff(ind_ii)/16,4,1) ;...
%             repmat(fff(ind_Ab)/4,2,1) ; repmat(fff(ind_Bb)/4,2,1) ;repmat(fff(ind_Cb)/4,2,1 ) ];
%         ind=ind+3;
%         indT=indT+6;
%         k=k+1;
%     catch
%     end
end

function [NFV,toremove]=relaxation(gravG,A,B,Cb,nT,nT2,NFV,ind)




% curvature computation based on edge AB and gravG Cb

AB=NFV.vertices(B,:)-NFV.vertices(A,:);
AG=gravG-NFV.vertices(A,:);
ACb=NFV.vertices(Cb,:)-NFV.vertices(A,:);
norm1=cross(AB,AG);
norm1=norm1/norm(norm1);
norm2=cross(ACb,AB);
norm2=norm2/norm(norm2);
angleAB=acos(norm1*norm2');

BG=-AB+AG;
BCb=-AB+ACb;
norm1=cross(AG,ACb);
norm1=norm1/norm(norm1);
norm2=cross(BCb,BG);
norm2=norm2/norm(norm2);
angleGCb=acos(norm1*norm2');

if angleAB<angleGCb
    NFV.faces=[NFV.faces;A B ind];
    toremove=nT;
else
    NFV.faces=[NFV.faces;A Cb ind;B ind Cb];
    toremove=[nT,nT2];
end

function [indices]=calcul_indices(indices,toremove);

for ii=1:length(indices)
    l=find(indices(ii)>toremove);
    indices(ii)=indices(ii)-length(l);
end
