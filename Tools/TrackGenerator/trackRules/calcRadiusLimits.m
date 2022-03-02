function [r_min,r_max] = calcRadiusLimits(v,R_min)
% function [r_min,r_max] = calcRadiusLimits(v,R_min)
%
% In:
%   v in km/h
%   R_min in m
%
% Out:
%   r_min in m
%   r_max in m
%
    
v = abs(v);
R_min = abs(R_min);

% see: L. Fendrich and W. Fengler, Handbuch Eisenbahninfrastrukur, S. 617
r_min = ceil(max(R_min,1.25*11.8*v^2/290)); 
r_max = floor(min(0.5*v^2,25e3));

end % end function