function [tg_basis]=ortho_basis(norm_coord,type)
% Gives an orthonormal basis orthogonal to one or several vectors
% INPUTS :
% norm_coord : list of 3D vectors
% type : 'uniform', 'polar' determines the structure of the orthonormal
% basis
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr    |
%|                                      | 
%\--------------------------------------/

n=size(norm_coord,1);
for ii=1:n
    normal=-norm_coord(ii,:);
    n1=normal(1);
    n2=normal(2);
    n3=normal(3);
    r=sqrt(n1^2+n2^2);
    if r==0
        tg_basis(ii,:,1)=[0 0 0];
        tg_basis(ii,:,2)=[0 0 0];
    else

        switch type
            case 'polar'
                if r==0
                    tg_basis(ii,:,1)=[1 0 0];
                    tg_basis(ii,:,2)=[0 1 0];
                else

                    ux=[-n2 n1 0];
                    uy=cross(normal,ux);
                    tg_basis(ii,:,1)=ux./repmat(sqrt(sum(ux.^2,2)),1,3);
                    tg_basis(ii,:,2)=uy./repmat(sqrt(sum(uy.^2,2)),1,3);
                end
            case 'uniform'
                U=[0; 0; 1];
                R=[n1 n2;-n2 n1]/r;
                e_theta=[n3*n1/r;n3*n2/r;-r];
                e_phi=cross(normal',e_theta);
                ux=[e_theta,e_phi]*R*[1;0];
                uy=cross(normal',ux);
                tg_basis(ii,:,1)=ux'./repmat(sqrt(sum(ux'.^2,2)),1,3);
                tg_basis(ii,:,2)=uy'./repmat(sqrt(sum(uy'.^2,2)),1,3);
        end
    end
end


