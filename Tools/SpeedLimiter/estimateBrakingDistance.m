function braking_distance = estimateBrakingDistance(v_current,delta_v,a_limits)
% braking_distance = estimateBrakingDistance(delta_v,a_limits)
%
% In:
%   v_current         in m/s
%   delta_v           in m/s
%   a_limits          [a_min, a_max] in m/s^2
%
% Out: 
%   braking_distance  in m
%

% Init ____________________________________________________________________

max_dec = abs(a_limits(1));
safety_factor = 1;

braking_distance = zeros(1,length(delta_v));

% Calculations ____________________________________________________________

for i = 1:length(delta_v)
    delta_v_i = delta_v(i);
    
    if delta_v_i < 0
        braking_distance(i) = 0;
        return
    else
        delta_t_braking = delta_v_i/max_dec;
        braking_distance(i) = v_current*delta_t_braking - (1/2*max_dec*delta_t_braking^2) * safety_factor;
    end % if
end % for i
             
end % function
