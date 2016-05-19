function [Vv,card]=tri2vert(Vt,VertFaceConn,Pn)
% Transform a face-based vector field to a vertex based vector field
% 
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

for ii=1:size(VertFaceConn,1)
    Vv(ii,:)=(sum(Vt(VertFaceConn{ii},:),1))*Pn(:,:,ii); %average + projection 
    card(ii)=length(VertFaceConn{ii});
end

Vv=Vv./repmat(card',1,3);