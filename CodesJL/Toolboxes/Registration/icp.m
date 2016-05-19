function [verts1,verts2,R,T,E]=icp(verts1,verts2,n)
%--------------------------------------------------------------------
% ICP for 3D registration of point clouds
% If n==0, it simply applies a coarse alignment based on PCA
%
% Ref: Besl P.J., McCay N. D., A method for registration of 3-D shapes,
% IEEE PAMI, 14, 239-256, 1992
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr         |
%|                                      | 
%\--------------------------------------/

%-----------------
% initialisation
%-----------------

R=0;
T=0
E=0;

% ACP

disp('Initialisation')
[COEFF2, SCORE2, LATENT2] = princomp(verts2);
[COEFF, SCORE, LATENT] = princomp(verts1);

% verts1=verts1-repmat(mean(verts1),length(verts1),1);
% verts1=verts1./repmat(std(verts1),length(verts1),1);
% verts2=verts2-repmat(mean(verts2),length(verts2),1);
% verts2=verts2./repmat(std(verts2),length(verts2),1);

verts1=SCORE*sqrt(diag(LATENT2./LATENT));
verts2=SCORE2;
disp('Test 8 combination')
%Rinit=COEFF2'*COEFF;
combinaison=zeros(8,3);
cpt=1;
for ii=-1:2:1
    for jj=-1:2:1
        for kk=-1:2:1
            combinaison(cpt,:)=[ii jj kk];
            D=diag(combinaison(cpt,:));
            idx=nearestneighbour(verts2',D*verts1');
            erreur(cpt)=norm(verts1(idx,:)'-D*verts2');
            cpt=cpt+1;
        end
    end
end

[~,ind]=min(erreur);
D=diag(combinaison(ind,:));
verts1=(D*verts1')';

%------------------
% Main loop
%------------------

for ii=1:n
    tic
   %[nn_verts1,verts2]=icp_label(verts1,verts2); % Matching of points
   idx=nearestneighbour(verts2',verts1');
   E(ii)=norm(verts1(idx,:)'-D*verts2');
   nn_verts1=verts1(idx,:);
   disp('Matching Step')
   toc
   tic
   [R,T]=icp_motion(nn_verts1,verts2); % Estimation of motion (least-squares)
   verts2=(R'*verts2'+repmat(T,1,size(verts2,1)))';
   disp('Estimation of motion')
   toc
end


function [nn_verts1,verts2]=icp_label(verts1,verts2)

N=size(verts1,1);
N2=size(verts2,1);
for ii=1:N2
    [v,ind]=min(norlig(repmat(verts2(ii,:),N,1)-verts1));
    indices(ii)=ind;
end
nn_verts1=verts1(indices,:);

function [R,T]=icp_motion(verts1,verts2)
% Ref : Besl McKay
% verts1 = X
% verts2 : P
N=length(verts1);
mu1=mean(verts1,1);
mu2=mean(verts2,1);
%s=sqrt(sum(sum((verts1-repmat(mu1,size(verts1,1),1)).^2,1),2)/sum(sum((verts2-repmat(mu2,size(verts2,1),1)).^2,1),2)); % scaling

sigma=(1/N)*(verts1-repmat(mu1,N,1))'*(verts2-repmat(mu2,N,1));
A23=sigma(2,3)-sigma(3,2);
A31=sigma(3,1)-sigma(1,3);
A12=sigma(1,2)-sigma(2,1);

QQ=[A23 A31 A12;sigma+sigma'-(trace(sigma))*eye(3)]';
Q=[trace(sigma) A23 A31 A12;QQ];

[V,D]=eig(Q);
[M,ind]=max(diag(D));

q=V(:,ind);
R=quaternion2rotation(q);
%R=s*R;
T=mu1'-R*mu2';

function [R]=quaternion2rotation(q);
q0=q(1);
q1=q(2);
q2=q(3);
q3=q(4);

R=[q0^2+q1^2-q2^2-q3^2, 2*(q1*q2-q0*q3), 2*(q1*q3+q0*q2);
   2*(q1*q2+q0*q3),q0^2+q2^2-q1^2-q3^2 ,2*(q2*q3-q0*q1);
   2*(q1*q3-q0*q2),2*(q2*q3+q0*q1),q0^2+q3^2-q1^2-q2^2];


