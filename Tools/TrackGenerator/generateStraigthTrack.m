function track_map = generateStraigthTrack(track_id,v_max,track_length)
% track_map = generateStraigthTrack(track_id,v_max,track_length)
%
% In:
%   track_id as integer number
%   v_max in km/h
%   track_length in m
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

if v_max < 0
    error('''v_max'' has to be greater or equal to zero!');
end % if

if track_length <= 0
    error('''L'' has to be greater than zero!');
end % if

if (length(track_id) > 1) || (length(v_max) > 1) || (length(track_length) > 1)
    error('One or more input arguments have a wrong length!');
end % if    

%% Calculations

track_map = table;
track_map.ID = track_id;
track_map.track_element = 1;
track_map.r_start = 0;
track_map.r_end = 0;
track_map.length = abs(track_length);
track_map.speed_limit = calcSpeedLimit(v_max,0);
track_map.cov = {zeros(3)};

[track_map,~] = orderTableTrackMap(track_map);

end
