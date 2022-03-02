function track_map = generateRoundTrack(track_id,v_max,radius)
% function track_map = generateRoundTrack(track_id,v_max,radius)
%
% In:
%   track_id as integer number
%   v_max in km/h
%   radius in m
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

if (length(track_id) > 1) || (length(v_max) > 1) || (length(radius) > 1)
    error('One or more input arguments have a wrong length!');
end % if    

%% Calculations

track_map = table;
track_map.ID = track_id;
track_map.track_element = 3;
track_map.r_start = radius;
track_map.r_end = radius;
track_map.length = 2*pi*abs(radius);
track_map.speed_limit = calcSpeedLimit(v_max,radius);
track_map.cov = {zeros(3)};

[track_map,~] = orderTableTrackMap(track_map);

end
