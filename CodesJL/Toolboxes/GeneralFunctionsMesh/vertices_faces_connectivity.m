function [VertFaceConn,Pn]=vertices_faces_connectivity(FV,norm_vert)

VertFaceConn=cell(size(FV.vertices,1),1);
for tt=1:size(FV.faces)
    for ind=FV.faces(tt,:);
        VertFaceConn{ind,1}=[VertFaceConn{ind,1};tt];
    end
end

% projection of flows.V(i,:,t) on the triangle i
for ii=1:size(FV.vertices)
   Pn(:,:,ii)=eye(3)-(norm_vert(ii,:)'*norm_vert(ii,:)); 
end

