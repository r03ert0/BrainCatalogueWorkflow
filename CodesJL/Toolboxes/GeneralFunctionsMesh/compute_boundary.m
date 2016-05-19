function boundary=compute_boundary(face)
%bu
% compute_boundary - compute the vertices on the boundary of a 3D mesh
%
%   boundary=compute_boundary(face);
%
%   Copyright (c) 2007 Gabriel Peyre

% if size(face,1)<size(face,2)
%     face=face';
% end

%%% compute edges (i,j) that are adjacent to only 1 face
A = compute_edge_face_ring(face');
[i,j,v] = find(A);
i = i(v==-1);
j = j(v==-1);
clear A
if isempty(i)||isempty(j)
    boundary=[];
else
    %%% build the boundary by traversing the edges
    boundary{1} = [i(1),j(1)]; i(1) = []; j(1) = [];
    bi=1;
    reverse=1;
    while not(isempty(i))
        b = boundary{bi}(end);
        I = find(i==b,1);
        if isempty(I)          
            I = find(j==b,1);
            if isempty(I)
                if reverse
                    boundary{bi}=boundary{bi}(end:-1:1);
                    reverse=0;
                else%%% multiple boundaries in this patch
                    %warning('Problem with boundary');
                    bi=bi+1;
                    reverse=1;
                    boundary{bi} = [i(1),j(1)];
                    i(1) = [];
                    j(1) = [];
                    %break;
                end
            else
                boundary{bi}(end+1) = i(I(1));
                i(I(1)) = []; j(I(1)) = [];
            end
            
        else
            boundary{bi}(end+1) = j(I(1));
            i(I(1)) = []; j(I(1)) = [];
        end
    end
    for b=1:length(boundary)
        if boundary{b}(1)==boundary{b}(end)
            boundary{b}(end)=[];
        end
    end

%      %%% build the boundary by traversing the edges
%     boundary{1} = i(1); i(1) = []; j(1) = [];
%     bi=1;
%     while not(isempty(i))
%         b = boundary{bi}(end);
%         I = find(i==b);
%         if isempty(I)
%             I = find(j==b);
%             if isempty(I)%%% multiple boundaries in this patch
%                 %warning('Problem with boundary');
%                 bi=bi+1;
%                 boundary{bi} = i(1);
%                 i(1) = [];
%                 j(1) = [];
%                 %break;
%             else
%                 boundary{bi}(end+1) = i(I(1));
%             end
%             
%         else
%             boundary{bi}(end+1) = j(I(1));
%         end
%         i(I) = []; j(I) = [];
%     end
    
%      colors=['r','c','g','y','b','k','m'];
%         i=1;
%         figure
%         plot_mesh_peyre(FV.vertices',face');shading('faceted');
%         for b=1:length(boundary)
%             hold on
%             c=colors(i);
%             i=i+1;
%             if i>length(colors)
%                 i=1;
%             end
%             plot3(FV.vertices(boundary{b},1),FV.vertices(boundary{b},2),FV.vertices(boundary{b},3),c,'LineWidth',2 );
%         end
%         
     
    
    
%     %%% concatenate boundary pieces
%     if length(boundary)>1
%         for bi=length(boundary):-1:2
%             for bi2=1:bi-1
%                 
%                 if (boundary{bi}(1)==boundary{bi2}(1))
%                     boundary{bi2}=[boundary{bi}(end:-1:2),boundary{bi2}];
%                     boundary(bi)=[];
%                     break
%                 else
%                     if (boundary{bi}(1)==boundary{bi2}(end))
%                         boundary{bi2}=[boundary{bi2}(1:end-1),boundary{bi}];
%                         boundary(bi)=[];
%                         break
%                     else
%                         if (boundary{bi}(end)==boundary{bi2}(1))
%                             boundary{bi2}=[boundary{bi}(1:end-1),boundary{bi2}];
%                             boundary(bi)=[];
%                             break
%                         else
%                             if (boundary{bi}(end)==boundary{bi2}(end))
%                                 boundary{bi2}=[boundary{bi2},boundary{bi}(end-1:-1:1)];
%                                 boundary(bi)=[];
%                                 break
%                             end
%                         end
%                     end
%                 end
%             end
%             
%         end
%     end
    
    %%% cut complex boundaries
    for bi=1:length(boundary)
        tf=unique(boundary{bi});
        di=length(boundary{bi})-length(tf);
        if di>0
            while di>0
                B = sort(boundary{bi});
                tf(end+1:end+di)=0;
                ind=find(tf-B,1,'first');
                double_ind=find(boundary{bi}==B(ind));
                double_ind(2)=double_ind(2)-1;
                boundary{length(boundary)+1}=boundary{bi}(double_ind(1):double_ind(2));
                boundary{bi}(double_ind(1):double_ind(2))=[];
                tf=unique(boundary{bi});
                di=length(boundary{bi})-length(tf);
                
            end
        end
        %     if length(unique(boundary{bi}))<length(boundary{bi})
        %         b_cur=bi;
        %         b_tmp=boundary{b_cur};
        %         boundary{b_cur}=boundary{b_cur}(1);
        %         for v=2:length(b_tmp)
        %             if isempty(find(boundary{b_cur}==b_tmp(v),1))
        %                 boundary{b_cur}(end+1)=b_tmp(v);
        %             else
        %                 b_cur=length(boundary)+1;
        %                 boundary{b_cur}=b_tmp(v);
        %             end
        %         end
        %     end
    end
    
    %%% order the boundaries for consistency
    for bi=1:length(boundary)
        if (boundary{bi}(end)<boundary{bi}(1))
            boundary{bi}=boundary{bi}(end:-1:1);
        end
    end
end
return;

%%% OLD CODE %%

nvert=max(max(face));
nface=size(face,1);


% count number of faces adjacent to a vertex
A=sparse(nvert,nvert);
for i=1:nface
    if verb
        progressbar(i,nface);
    end
    f=face(i,:);
    A(f(1),f(2))=A(f(1),f(2))+1;
    A(f(1),f(3))=A(f(1),f(3))+1;
    A(f(3),f(2))=A(f(3),f(2))+1;
end
A=A+A';

for i=1:nvert
    u=find(A(i,:)==1);
    if ~isempty(u)
        boundary=[i u(1)];
        break;
    end
end

s=boundary(2);
i=2;
while(i<=nvert)
    u=find(A(s,:)==1);
    if length(u)~=2
        warning('problem in boundary');
    end
    if u(1)==boundary(i-1)
        s=u(2);
    else
        s=u(1);
    end
    if s~=boundary(1)
        boundary=[boundary s];
    else
        break;
    end
    i=i+1;
end
       
if i>nvert
    warning('problem in boundary');
end


%%% OLD %%%
function v = compute_boundary_old(faces)

nvert = max(face(:));
ring = compute_vertex_ring( face );

% compute boundary
v = -1;
for i=1:nvert   % first find a starting vertex
    f = ring{i};
    if f(end)<0
        v = i;
        break;
    end
end
if v<0
    error('No boundary found.');
end
boundary = [v];
prev = -1;
while true
    f = ring{v};
    if f(end)>=0
        error('Problem in boundary');
    end
    if f(1)~=prev
        prev = v;
        v = f(1);
    else
        prev = v;
        v = f(end-1);
    end
    if ~isempty( find(boundary==v) )
        % we have reach the begining of the boundary
        if v~=boundary(1)
            warning('Begining and end of boundary doesn''t match.');
        else
            break;
        end
    end
    boundary = [boundary,v];
end