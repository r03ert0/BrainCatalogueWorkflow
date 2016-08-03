function [normals_v,normals_t]=vertex_normals(FV)

[~,~,normals]=carac_tri(FV.faces,FV.vertices,3);
    %Make the normals unit norm
   [nrm,normals_t]=colnorm(normals');
   
   normals_v=zeros(3,length(FV.vertices));
   for t=1:length(FV.faces)
        indices=FV.faces(t,:);
        for i=indices
            normals_v(:,i)=normals_v(:,i)+normals_t(:,t);
        end
   end
   
   for v=1:length(FV.vertices)
      normals_v(:,v)=normals_v(:,v)/norm(normals_v(:,v)); 
   end
      