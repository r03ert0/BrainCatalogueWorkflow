function [aires_lissees,volumes_lissees,smoothedFV,A]=smoothing_A_V(FVl,type_smoothing,dt,Nlissage,A)

% Step 1: Smoothing

vertConn=vertices_connectivity(FVl);

if isequal(type_smoothing,'finite_diff')
    if nargin<3
        dt=0.1;
        Nlissage=1000; % 700 must be enough
    end
    for k=1:Nlissage
        if k==1 & nargin<5
            [smoothedFV,A]=smooth_cortex(FVl,vertConn,dt,1);
        elseif k==1 & nargin==5
                smoothedFV.vertices=A*FVl.vertices;
                smoothedFV.faces=FVl.faces;
        else
            smoothedFV.vertices=A*smoothedFV.vertices;
        end
        [~,saires,~]=carac_tri(smoothedFV.faces,smoothedFV.vertices,3);
        aires_lissees(k)=sum(saires);
        volumes_lissees(k)=surface_volume(smoothedFV);
        k
    end
else
    
end