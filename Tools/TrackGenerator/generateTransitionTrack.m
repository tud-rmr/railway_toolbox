function track_map = generateTransitionTrack(track_id,v_max,transition_height,transition_length)
% track_map = generateTransitionTrack(track_id,v_max,transition_height,transition_length)
%
% In:
%   track_id as integer number
%   v_max in km/h
%   transition_height in m
%   transition_length in m
%
% Out:
%   track_map as table
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

if v_max <= 0
    error('''v_max'' has to be greater than zero!');
end % if

if (length(track_id) > 1) || (length(v_max) > 1) || (length(transition_height) > 1) || (length(transition_length) > 1)
    error('One or more input arguments have a wrong length!');
end % if

track_elements = [2 1 4]';
track_start_radii = zeros(3,1);
track_end_radii = zeros(3,1);
track_speed_limits = zeros(3,1);
track_minimal_lengths = zeros(3,1);
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
% opts = optimoptions(@fmincon);
obj_fcn_wrapper = @(x) objectiveFunction(x,abs(transition_height),abs(transition_length),track_map);

x_0 = [abs(transition_length/4); abs(transition_height/2);abs(transition_height)]; % [L_clothoid, R_clothoid, L_straight]
lower_bounds = [0;0;0.8*abs(transition_height)]; % [L_clothoid, R_clothoid, L_straight]
upper_bounds = [abs(transition_length);2*abs(max(transition_height,transition_length));norm(transition_length,transition_height)]; % [L_clothoid, R_clothoid, L_straight]

x_opt = fmincon(obj_fcn_wrapper,x_0,[],[],[],[],lower_bounds,upper_bounds,[],opts);

track_map.length([1 3]) = x_opt(1);
track_map.length(2) = x_opt(3);

track_map.r_end(1) = -x_opt(2);
track_map.r_start(3) = x_opt(2);
if transition_height < 0   
    track_map.r_end(1) = x_opt(2);
    track_map.r_start(3) = -x_opt(2);
end % if

track_map.speed_limit = arrayfun(@(arr) calcSpeedLimit(v_max,arr),track_map.r_end);

[track_map,~] = orderTableTrackMap(track_map);

end

function J = objectiveFunction(x,transition_height,transition_length,track_map)
% J = objectiveFunction(x,transition_height,transition_length,Trackmap)
%
% In:
%   x --> parameters being optimized
%   transition_height in m
%   transition_length in m
%   track_map as table
%
% Out:
%   J = objective value

track_map.length([1 3]) = x(1);
track_map.length(2) = x(3);

track_map.r_end(1) = -x(2);
track_map.r_start(3) = x(2);

L_end = sum(track_map.length);

[~,~,~,p,~,~,~,~] = calcTrackProperties(L_end,track_map.ID(1),0,track_map);

x_error = (transition_length - p(1,1))/transition_length;
y_error = (transition_height - p(2,1))/transition_height;

J = x_error^2 + y_error^2;

end

