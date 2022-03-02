function v_max_i = calcSpeedLimit(v,R)
% function v_max_i = calcSpeedLimit(v,R)
%
% In:
%   v in km/h
%   R in m
%
% Out:
%   v_max in km/h
%
    
v = abs(v);
R = abs(R);
if (nargin == 1) || (R == 0)
    v_max_i = v;
else
    v_max_i = min(v,sqrt((R*290)/(1.25*11.8))); % see: L. Fendrich and W. Fengler, Handbuch Eisenbahninfrastrukur, S. 617
end % if
% v_max_i = floor(v_max_i/10)*10;
v_max_i = floor(v_max_i);
    
end % end function