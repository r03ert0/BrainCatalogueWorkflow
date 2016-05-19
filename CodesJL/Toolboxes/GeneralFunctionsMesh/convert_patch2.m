function [PFV,Transfo]=convert_patch2(P,FV,F)
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
tic

if nargin<3
    F=zeros(length(FV.vertices),1);
end

% Nodes
Transfo=zeros(length(FV.vertices),1); % transformation inverse de P(i)=j, P(1)=n_1, P(l)=n_l, on veut P^{-1}(n_i) 

for ii=1:length(P)
    Transfo(P(ii))=ii;
%     if mod(ii,1000)==0
%         disp(ii)
%     end
end


% Triangles
if length(P)>length(FV.vertices)/2
    P2=setdiff(1:length(FV.vertices),P);
    disp('Optimisation')
else
    P2=P;
end

liste_T=[];
for ind=1:length(P2)
    [ii,jj]=find(FV.faces==P2(ind)); % long
    liste_T=[ii; liste_T];
%     if mod(ind,1000)==0
%         disp(ind)
%     end
end

if length(P)>length(FV.vertices)/2
    liste_T=setdiff(1:length(FV.faces),liste_T);
end

liste_T=unique(liste_T);
PFV.faces=Transfo(FV.faces(liste_T,:));
PFV.vertices=FV.vertices(P,:);

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
%     if mod(ii,500)==0
%         disp(ii)
%     end
end
PFV.vertices=FV.vertices(goodnode,:);

% Transfo=zeros(length(PFV.vertices),1);
% for ii=1:length(PFV.vertices)
%     Transfo(P(ii))=ii;
% %     if mod(ii,1000)==0
% %         disp(ii)
% %     end
% end


liste=setdiff(1:length(P),unique(PFV.faces(:)));

liste=sort(liste);
tmp = PFV.faces;
for s=1:(size(liste,1)*size(liste,2)),
    [i, j] = find(tmp > liste(s));
    if isempty(i)
    else
        for z=1:length(i),
            PFV.faces(i(z),j(z))=PFV.faces(i(z),j(z))-1;
        end
    end
end

for i=1:length(liste)
    ind = find(Transfo==liste(i));
    Transfo(ind)=0;
end

% for ii=1:length(P),
%     c=1;
%     for j=1:length(liste)
%         if ii==liste(j),
%             c=c+1;
%         end
%     end
%     if c==1,
%         Transfo1(P(ii),1)=ii;
%     end
% end


toc

return

function [convtri]=convert(tri,P)

ind1=find(P==tri(1));
ind2=find(P==tri(2));
ind3=find(P==tri(3));

convtri=[ind1 ind2 ind3];