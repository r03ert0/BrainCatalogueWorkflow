function X=smooth_cortical_maps(FV,map,niter,tau,VERBOSE,options)
% Very similar to heat_equation but yields a supplementary quality check by
% plotting the distribution of smoothed maps

%/---Script Authors---------------------\
%|                                      | 
%|   *** J.Lefèvre, PhD                 |  
%|   julien.lefevre@chups.jussieu.fr    |
%|                                      | 
%\--------------------------------------/

if nargin<6
    options=[];
end

niter=10;
tau=0.1;
X=heat_equation(map,[],FV.faces,FV.vertices,niter,tau);

if VERBOSE
    
    figure
    subplot(2,2,1)
    couleur=jet(niter);
    [nc,bins]=hist(map,100);
    plot(bins,nc/sum(nc),'k')
    hold on
    for k=1:niter
        nc=hist(X(:,k),bins);
        plot(bins,nc/sum(nc),'Color',couleur(k,:))
    end
    title('Distribution of smoothed maps')
    m=min(map);
    M=max(map);
    mu=mean(map);
    subplot(2,2,2)
    my_view_surface(FV,map-mu,options)
    caxis([m/2,M/2])
    view(-90,0)
    subplot(2,2,4)
    my_view_surface(FV,X(:,niter)-mu,options)
    caxis([m/2,M/2])
    view(-90,0)
    
end
X=X(:,niter);