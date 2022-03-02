function track_map = generateTurnTrack(track_id,v_max,radius,turn_in_deg)
% track_map = generateTurnTrack(track_id,v_max,radius,turn_in_deg)
%
% In:
%   track_id as integer number
%   v_max in km/h
%   radius in m
%   turn_in_deg in degree [-360 ... 360]
%
% Out:
%   track_map as table
% 
% Radius interpretation:
%   positiv radius--> right turn in driving direction
%   negativ radius--> left turn in driving direction
% For definition see: Volker Matthews. Bahnbau (7. Auflage), S. 99
% 
% Track element types:
% -----|--------------------
%   #  | Type
% -----|--------------------
%   1  | straight
%   2  | normal clothoid
%   3  | circular arc
%   4  | reverse clothoid
%   5  | turn clothoid
%

%% Initialization and checks

% if R == 0
%     error('''R'' has to be unequal zero!');
% end % if

if v_max <= 0
    error('''v_max'' has to be greater than zero!');
end % if

if turn_in_deg == 0
    error('''turn_in_deg'' has to be unequal zero!');
end % if

if (length(track_id) > 1) || (length(v_max) > 1) || (length(radius) > 1) || (length(turn_in_deg) > 1)
    error('One or more input arguments have a wrong length!');
end % if

turn_in_deg = sign(turn_in_deg)*mod(abs(turn_in_deg),360);
radius = abs(radius);

track_elements = [2 3 4]';
track_start_radii =  sign(turn_in_deg)*[0 radius radius]';
track_end_radii = sign(turn_in_deg)*[radius radius 0]';
track_speed_limits = arrayfun(@(arr) calcSpeedLimit(v_max,arr),max(abs(track_start_radii),abs(track_end_radii)));
track_minimal_lengths = arrayfun(@(arr1,arr2,arr3) calcMinimumTrackElementLength(arr1,arr2,arr3),track_elements,track_speed_limits,max(abs(track_start_radii),abs(track_end_radii)));
track_cov = repmat({zeros(3)},length(track_elements),1);

track_map = table;
track_map.ID = repmat(track_id,length(track_elements),1);
track_map.track_element = track_elements;
track_map.r_start = track_start_radii;
track_map.r_end = track_end_radii;
track_map.length = track_minimal_lengths;
track_map.speed_limit = track_speed_limits;
track_map.cov = track_cov;

%% Calculations

opts = optimoptions(@fmincon,'Display','off');
obj_fcn_wrapper = @(x) objectiveFunction(x,track_map,turn_in_deg);

l_0 = track_minimal_lengths(2);
lower_bounds = track_minimal_lengths(2);
upper_bounds = 2*pi*abs(radius)*abs(turn_in_deg)/360;

l_opt = fmincon(obj_fcn_wrapper,l_0,[],[],[],[],lower_bounds,upper_bounds,[],opts);

track_map.length(2) = l_opt(1);

[track_map,~] = orderTableTrackMap(track_map);

end

function J = objectiveFunction(x,track_map,turn_in_deg)
% J = objectiveFunction(x,Trackmap,turn_in_deg)
%
% In:
%   x --> parameters being optimized
%   track_map as table
%   turn_in_deg in degree
%
% Out:
%   J = objective value

track_map.length(2) = x(1);

L_end = sum(track_map.length);
[~,~,~,~,t,~,~,~] = calcTrackProperties(L_end,track_map.ID(1),0,track_map);

phi_current = -atan2d(t(2,1),t(1,1));
if (abs(turn_in_deg) > 180) && (sign(phi_current) ~= sign(turn_in_deg))
    phi_current = sign(turn_in_deg)*360+phi_current;
end

J = (turn_in_deg-phi_current)^2;

end

