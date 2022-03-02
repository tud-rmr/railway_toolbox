function track_map = generateEightShapedTrack(track_id,v_max,radius,curvature_factor)
% track_map = generateEightShapedTrack(track_id,v_max,radius,curvature_factor)
%
% In:
%   track_id as integer number
%   v_max in km/h
%   radius in m
%   curvature_factor = [0 ... 1]
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

if (curvature_factor < 0) || (curvature_factor > 1)
    error('''curvature_factor'' has to be within 0...1!');
end % if

if (length(track_id) > 1) || (length(v_max) > 1) || (length(radius) > 1) || (length(curvature_factor) > 1)
    error('One or more input arguments have a wrong length!');
end % if

track_elements = [3 5 3 5 3]';
track_start_radii = -1*[-radius -radius radius radius -radius]';
track_end_radii = -1*[-radius radius radius -radius -radius]';
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
obj_fcn_wrapper = @(x) objectiveFunction(x,track_map,curvature_factor);

l_0 = [pi*abs(radius);track_minimal_lengths(2)];
lower_bounds = [track_minimal_lengths(3);track_minimal_lengths(2)];
upper_bounds = [2*pi*abs(radius);pi*abs(radius)];

l_opt = fmincon(obj_fcn_wrapper,l_0,[],[],[],[],lower_bounds,upper_bounds,[],opts);

track_map.length([1 5]) = l_opt(1)/2;
track_map.length([2 4]) = l_opt(2);
track_map.length(3) = l_opt(1);

[track_map,~] = orderTableTrackMap(track_map);

end

function J = objectiveFunction(x,track_map,curvature_factor)
% J = objectiveFunction(x,track_map,curvature_factor)
%
% In:
%   x --> parameters being optimized
%   track_map as table
%   curvature_factor = [0 ... 1]
%
% Out:
%   J = objective value

track_map.length([1 5]) = x(1)/2;
track_map.length([2 4]) = x(2);
track_map.length(3) = x(1);

L_end = sum(track_map.length);
l = [0,L_end/4,L_end];

% Trackmap = table_track_map2mat_track_map(track_map);
% p = calcTrackPosition(l,Trackmap);

[~,~,~,p] = calcTrackProperties(l,track_map.ID(1),0,track_map);

distance_center = norm(p(:,2));
distance_start_to_end = norm(p(:,1) - p(:,end));
w = (1-curvature_factor);

J = distance_start_to_end + w*distance_center;

end

