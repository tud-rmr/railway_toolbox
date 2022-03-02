function [track_id,track_rel_position,track_element_rel_position] = getTrackRelPosition(track_map_abs_position,track_map)
% [track_id,track_rel_position,track_element_rel_position] = getTrackRelPosition(track_map_abs_position,track_map)
%
% In:
%   track_map_abs_position  position in meters relative to the given trackmap
%   track_map               trackmap as table or matrix
%
% Out:
%   track_id                        track ID of the current track the train is on
%   track_rel_position              position of the train in meters, relative to the given track ID
%   track_element_rel_position      position of the train in meters, relative to the current track element with the current track ID
%

%% Initialization and checks

% Conversion from 'track_map' in table format to matrix format, because of
% performance issues!
[~,track_ids,~,~,~,~,~,~] = tableTrackMap2matTrackMap(track_map);

% Initialize output variables
track_id = zeros(1,length(track_map_abs_position));
track_rel_position = zeros(1,length(track_map_abs_position));
track_element_rel_position = zeros(1,length(track_map_abs_position));

%% Calculations

number_of_track_elements = size(track_map,1);
[track_element_starting_points,~] = getTrackElementEndPoints(1:number_of_track_elements,track_map);
track_element_indices = getTrackElementIndex(track_map_abs_position,track_map);

for pos_index = 1:length(track_map_abs_position)    
    current_track_map_abs_position = track_map_abs_position(pos_index);
    current_track_element_index = track_element_indices(pos_index);
    
    track_id(pos_index) = track_ids(current_track_element_index);
    track_element_rel_position(pos_index) = current_track_map_abs_position - track_element_starting_points(current_track_element_index);
    track_rel_position(pos_index) = current_track_map_abs_position - min(track_element_starting_points(track_ids == track_id(pos_index))); 
end % for

end

