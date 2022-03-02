function [track_map_abs_position] = getTrackAbsPosition(track_id,track_rel_position,track_map)
% [track_map_abs_position] = getTrackAbsPosition(track_id,track_rel_position,track_map)
%
% In:
%   track_id                track ID of the current track the train is on
%   track_rel_position      position of the train in meters, relative to the given track ID
%   track_map               trackmap as table or matrix
%
% Out:
%   track_map_abs_position  position in meters relative to the given trackmap
%

%% Initialization and checks

% Conversion from 'track_map' in table format to matrix format, because of
% performance issues!
[~,track_ids,~,~,~,track_lengths,~,~] = tableTrackMap2matTrackMap(track_map);

if ~all(size(track_id) == size(track_rel_position))
    error('Dimension mismatch between ''track_ID'' and ''track_rel_position''!');
end % if

if ~any(track_id == track_ids)
    error('Track not contained in given trackmap!')
end % if

% Initialize output variables
track_map_abs_position = zeros(1,length(track_id));

%% Calculations

% Transform track relative coordinates (track_id,track_rel_position) to 
% trackmap relative coordinates (distance measured from the first track 
% element in the map)
for pos_index = 1:length(track_id)    
    i = 1;
    while track_ids(i) ~= track_id(pos_index)
        track_map_abs_position(pos_index) = track_map_abs_position(pos_index) + track_lengths(i);
        i = i + 1;
    end % while
    track_map_abs_position(pos_index) = track_map_abs_position(pos_index) + track_rel_position;    
end % for

end

