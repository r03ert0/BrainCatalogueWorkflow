function syst=reaction_diffusion_dilution(syst,faces,vertices,n,tau,f,g,delta1,delta2,scheme,fff,FF,kk)
% Implements a reaction-diffusion equation of the form :
% dX/dt=laplacian(X)+f(X,Y)
% dY/dt=delta*laplacian(Y)+g(X,Y)
% if necessary we can add other coupled terms :
% dH/dt=X*H*(1-H) (+  laplacian(H))
%
% In practice only Gray-Scott model with implicit scheme has been tested
% Ref: J. Lefèvre, J.F. Mangin, A reaction-diffusion model of human brain
% development, PLoS Computational Biology
%
%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@univ-amu.fr    |
%|                                      | 
%\--------------------------------------/



if size(tau,1)==1
    [A2,G,grad_v,aires,index1,index2,cont_vv,B]=heat_matrices(faces,vertices,3,fff);
else
    [A2,G,grad_v,aires,index1,index2,cont_vv,B]=heat_matrices(faces,vertices,3,fff,tau);
end

NN=size(syst.X,1);

switch f
    case 'grayscott'
        alpha=1; %0.05
        r=0.001;
        F=alpha*(FF+(r-2*r*rand(NN,1))); % 0.045
        k=alpha*(kk+(r-2*r*rand(NN,1))); % 0.065
        kappa=0.005;
        f=@(x,y) F.*(1-x)-x.*y.^2;
        g=@(x,y) x.*y.^2-(F+k).*y;
        h=@(x) kappa*x.*(1-x);
    case 'grayscott_gradient'
        alpha=1;
        v=vertices(:,1);
        w=vertices(:,2);
        M=max(v);
        m=min(v);
        Fmax=alpha*0.039;
        Fmin=alpha*0.039;
        kmax=alpha*0.08;% 0.07 
        kmin=alpha*0.05;% 0.04
        r=0.001;
        F=Fmin+(Fmax-Fmin)*(v-m)/(M-m)+(r-2*r*rand(NN,1));
        k=kmin+(kmax-kmin)*(w-m)/(M-m)+(r-2*r*rand(NN,1));
        kappa=0.005;
        f=@(x,y)(1-x).*F-x.*y.^2;
        g=@(x,y) x.*y.^2-y.*(F+k);
        h=@(x) kappa*x.*(1-x);
    case 'brusselator'
        s=1;
        A=3;
        B=11;
        f=@(x,y) s*(A-(1+B)*x+x.^2.*y);
        g=@(x,y) s*(B*x-x.^2.*y);
    case 'turk'
        s=1/500;1/64;
        A=16;
        B=12;
        f=@(x,y) s*(A-x.*y);
        g=@(x,y) s*(x.*y-y-B);
    case 'null'
        f=@(x,y) 0;
        g=f;
    case 'fitzhughnagumo'
    case 'schnakenberg'
        %dt=0.1;
        a=0.12;
        b=0.9;
        %da=1;
        %db=0.05;
        f=@(x,y) b-x.*y.^2;
        g=@(x,y) a+x.*y.^2-y;
end

% Implicit scheme
% G(X^(n+1)-X^n)/tau+A2(X^(n+1))=C (C=0 to begin)
% (G+tau*A2)X=G*X quicker than explicit one (I+A\B)*X=A*X 

switch scheme
    case 'implicit'

        M=tau*delta1*A2+G+B;
        N=tau*delta2*A2+G+B;
        bool=isfield(syst,'U_0'); % boundary conditions
        if bool
            FV.faces=faces;
            FV.vertices=vertices;
            VertConn=vertices_connectivity(FV);
            % Dirichlet 
            U_0=syst.U_0;
            indices=find(U_0)';
            diff_indices=setdiff(1:NN,indices);
            BM=M(diff_indices,indices);
            M(indices,diff_indices)=0;
            M(diff_indices,indices)=0;
            BN=N(diff_indices,indices);
            N(indices,diff_indices)=0;
            N(diff_indices,indices)=0;
            for ii=indices
                M(ii,ii)=1;
                M(ii,VertConn{ii})=0;
                M(VertConn{ii},ii)=0;
                N(ii,ii)=1;
                N(ii,VertConn{ii})=0;
                N(VertConn{ii},ii)=0;
            end
        end
            
        for ii=1:n
            
            syst.X=syst.X+tau.*f(syst.X,syst.Y);
            syst.X=G*(syst.X);
            if bool
                syst.X(indices)=U_0(indices);
                syst.X(diff_indices)=(syst.X(diff_indices)-BM*U_0(indices));
            end
            syst.X=M\(syst.X);

            syst.Y=syst.Y+tau.*g(syst.X,syst.Y);
            syst.Y=G*(syst.Y);
            if bool
                syst.Y(indices)=U_0(indices);
                syst.Y(diff_indices)=(syst.Y(diff_indices)-BN*U_0(indices));
            end
            syst.Y=N\(syst.Y);       
        end
    case 'growth'
        growth=syst.growth; % must be of size n+1
        for ii=1:n
            r=2*(growth(ii+1)-growth(ii))/(tau*growth(ii));
            M=(delta1/growth(ii)^2)*A2+G;
            N=(delta2/growth(ii)^2)*A2+G;
            syst.X=syst.X+tau.*(f(syst.X,syst.Y)-r*syst.X);
            syst.X=G*(syst.X);
            syst.X=M\(syst.X);

            syst.Y=syst.Y+tau.*(g(syst.X,syst.Y)-r*syst.Y);
            syst.Y=G*(syst.Y);
            syst.Y=N\(syst.Y);
            
            syst.H=syst.H+(syst.Y).*h(syst.H);   
        end
        
    case 'explicit'
        %M=-tau*G\A2; too long
        for ii=1:n
           X=X+G\(tau*A2*X)+tau*f(X,Y);
           Y=Y+G\(tau*A2*Y)+tau*g(X,Y);
           
        end
        
end

return