function [PFV,PF,Ptriangles]=convert_patch(P,FV,F)
% function [PFV]=convert_patch(P,FV)
% -------------------------------------------------------------
% Given a list of connected nodes (P), gives the structure Faces Vertices of the
% patch
% --------------------------------------------------------------
% 
% INPUTS :
% - P : indices of connected nodes
% - FV : structure with fields faces, vertices ,i.e. corresponding to a
% tesselation
% - F : scalar field defined on nodes of FV
% OUTPUTS :
% - PFV : subtesselation of FV based on the nodes P with fields faces,
% vertices
% - PF : scalar field defined on the resulting submesh
% - Ptriangles : list of triangles of FV.faces that are implied in the new
% tesselation
% -------------------------------------------------------------------
% Author: Julien Lefèvre
% julien.lefevre@univ-amu.fr
% -------------------------------------------------------------------

if nargin<3
    F=zeros(length(FV.vertices),1);
end

PFV.vertices=FV.vertices(P,:);
T=[];
nT=1;
for ii=1:size(P,1)
   [ind_i,ind_j]=find(FV.faces==P(ii)); 
    for k=1:length(ind_i)
        if ismember(ind_i(k),T)
        else
            convtri=convert(FV.faces(ind_i(k),:),P);
            if length(convtri)<=2
            else
            PFV.faces(nT,:)=convtri;
            T=[ind_i(k) T];
            nT=nT+1;
            end
        end
    end
    if mod(ii,500)==0
        disp(ii)
    end
end
Ptriangles=T;

% last check : if a vertex is not connected to any other vertices remove it
if ~isfield(PFV,'faces')
    return
end
VertConn=vertices_connectivity(PFV,0);
goodnode=[];
cpt=1;
for ii=1:length(VertConn)
    if isempty(VertConn{ii})
    else
        goodnode=[goodnode, P(ii)];
        PF(cpt,:)=F(P(ii),:);
        cpt=cpt+1;
    end
    if mod(ii,500)==0
        disp(ii)
    end
end
PFV.vertices=FV.vertices(goodnode,:);

% reordering the labels of the triangles (could be more elegant but it
% works....)
liste=setdiff(1:length(P),unique(PFV.faces(:)));
% if length(liste)==1
%     liste=[liste length(P)+1];
% end
% for ii=1:length(liste)-1
%     indices=find(PFV.faces(:)>liste(ii) & PFV.faces(:)<=liste(ii+1));
%     if isempty(indices)
%         num=-2;
%     else
%         num=-1;
%     end
%     PFV.faces(indices)=PFV.faces(indices)+num;
% end

liste=sort(liste);
for i=1:prod(size(PFV.faces))
    ind=find(liste<PFV.faces(i));
    if isempty(ind)
    else
        PFV.faces(i)=PFV.faces(i)-length(ind);%(end);
    end
    if mod(i,500)==0
        disp(i)
    end
end

function [convtri]=convert(tri,P)

ind1=find(P==tri(1));
ind2=find(P==tri(2));
ind3=find(P==tri(3));

convtri=[ind1 ind2 ind3];