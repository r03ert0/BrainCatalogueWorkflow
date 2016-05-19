function [E,residuals,t_instants]=curves_error(C1,C2,b,temps,lambda)

% INPUTS:
% - C1: a 2xN vector of points (volume, surface)
% - C2: a 2xp vector of points (p<<N)
% - b: parameter that will modulate C1:
%   [C1(1,:).*exp(-3*b*temps);C2(2,:).*exp(-2*b*temps)]
% - temps: physical time
% - lambda: ratio to homogenize C1(1,:) and C2(2,:)
%
% OUPUTS :
% - residuals: errors between C1 and C2 with temporal modulation b
% - t_instants: temporal instants in C1 that correspond to each of the C2
%   sequence

C=[C1(1,:).*exp(-3*b*temps);C1(2,:).*exp(-2*b*temps)];

t_instants=zeros(1,size(C2,2));
residuals=zeros(1,size(C2,2));
%lambda=0;
for ii=1:size(C2,2)    
    [~,t_instants(ii)]=min((C(1,:)-C2(1,ii)).^2+lambda*(C(2,:)-C2(2,ii)).^2);
    residuals(ii)=C(2,t_instants(ii))-C2(2,ii); % be carefull if the sampling is not good enough
end
E=mean(residuals.^2);