function [rotated_partition,Rot,ind]=random_partitions(sphFV,IDX,Rot)


MeanSphere=mean(sphFV.vertices); % not (0,0,0) because of non uniform sampling
MeanSphere=MeanSphere/norm(MeanSphere);


if nargin<3
%     % old method
%     ind=randi(length(sphFV.vertices),1,1);
%     random_dir=sphFV.vertices(ind,:);
%     axe=cross(random_dir,MeanSphere);
%     axe=axe/norm(axe);
%     MeanSphere_o=cross(MeanSphere,axe);
%     MeanSphere_o=MeanSphere_o/norm(MeanSphere_o);
%     random_dir_o=cross(random_dir,axe);
%     random_dir_o=random_dir_o/norm(random_dir_o);
%     
%     P1=[MeanSphere' MeanSphere_o' axe'];
%     P2=[random_dir' random_dir_o' axe'];
%     R=P2*inv(P1);
%     % One random point on the discrete sphere + one random vector
%     ind=randi(length(sphFV.vertices),1,1);
%     random_dir=sphFV.vertices(ind,:);
%     phi=rand(1,1)*2*pi;
%     t=rand(1,1);
%     theta=acos(t);
%     [x,y,z]=sph2cart(phi,-theta+pi/2,1);
%     v=[x,y,z];
    % QR decomposition
        A=randn(3,3);
        [Q,R]=qr(A);
        Rot=Q*diag(sign(diag(R)));
end

%tic
rotated_partition=tex_to_mesh_SD(sphFV.vertices*Rot,sphFV,IDX);
%toc


ind=[];
