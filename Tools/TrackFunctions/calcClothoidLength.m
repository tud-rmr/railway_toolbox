function L = calcClothoidLength(R,t_start,t_end)
% L = calcClothoidLength(R,t_start,t_end)
% 
% In:
%   R           radius of the clothoid (the sign indicates the direction of the clothoid --> positive: left turn, negative: left turn)
%   t_start     tangent vector at the beginning of the clothoid (normalized)
%   t_end       tangent vector at the end of the clothoid (normalized)
%
% Out:
%   L           calculated length of the clothoid to reach 't_end'
% 

% Initialization and checks _______________________________________________

rotation_matrix = @(phi) [cos(phi/360*2*pi) -sin(phi/360*2*pi);sin(phi/360*2*pi) cos(phi/360*2*pi)];

% Calculate 'delta_phi' and corresponding tangential vector 't_end_new'
phi_start = atan2d(t_start(2),t_start(1));
phi_end = atan2d(t_end(2),t_end(1));
if (R < 0) && (abs(phi_start) <= 90)
    delta_phi = mod(phi_end-phi_start,360);
elseif (R < 0) && (abs(phi_start) > 90)
    delta_phi = -mod(phi_end-phi_start,360);
elseif (R >= 0) && (abs(phi_start) <= 90)
    delta_phi = -mod(phi_start-phi_end,360);
elseif (R >= 0) && (abs(phi_start) > 90)
    delta_phi = mod(phi_start-phi_end,360);
else
    error('calcClothoidLength: Unhandled case!');
end % if
t_end_new = [cosd(delta_phi);sind(delta_phi)];

% Correct values for further calculations
delta_phi = abs(delta_phi);
if (abs(phi_start) > 90)
    R = -1*R;
end % if

% Calculations ____________________________________________________________

L_temp = NaN(2,1);
if (R < 0)
    if (delta_phi >= 0) && (delta_phi <= 90)
        L_temp(1) = acos(t_end_new(1))*2*R;
        L_temp(2) = asin(t_end_new(2))*2*R;       
    elseif (delta_phi > 90) && (delta_phi <= 180)
        L_temp(1) = (2*pi - acos(t_end_new(1)))*2*R;
        L_temp(2) = (1*pi - asin(t_end_new(2)))*2*R;
    elseif (delta_phi > 180) && (delta_phi <= 270)
        L_temp(1) = (4*pi - acos(t_end_new(1)))*2*R;
        L_temp(2) = (3*pi - asin(t_end_new(2)))*2*R;
    elseif (delta_phi > 270) && (delta_phi <= 360)
        L_temp(1) = (2*pi + acos(t_end_new(1)))*2*R;
        L_temp(2) = (2*pi + asin(t_end_new(2)))*2*R;
    end % if
end % if
if (R >= 0)
    if (delta_phi >= 0) && (delta_phi <= 90)
        L_temp(1) = acos(t_end_new(1))*2*R;
        L_temp(2) = asin(t_end_new(2))*2*R;        
    elseif (delta_phi > 90) && (delta_phi <= 180)
        L_temp(1) = (2*pi - acos(t_end_new(1)))*2*R;
        L_temp(2) = (1*pi + asin(t_end_new(2)))*2*R;        
    elseif (delta_phi > 180) && (delta_phi <= 270)
        L_temp(1) = (4*pi - acos(t_end_new(1)))*2*R;
        L_temp(2) = (3*pi + asin(t_end_new(2)))*2*R;        
    elseif (delta_phi > 270) && (delta_phi <= 360)
        L_temp(1) = (2*pi + acos(t_end_new(1)))*2*R;
        L_temp(2) = (2*pi - asin(t_end_new(2)))*2*R;
    end % if 
end % if

% Output __________________________________________________________________

if all(isnan(L_temp))
    error('calcClothoidLength: Length not assigned!');
end % if

L = min(abs(L_temp));

end % function

