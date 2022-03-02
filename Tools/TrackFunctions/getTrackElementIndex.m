function track_element_index = getTrackElementIndex(track_map_abs_position,track_map)
% track_map_index = getTrackElementIndex(track_map_abs_position,track_map)
%
% In:
%   track_map_abs_position      position in meters, relative to the given track map (array mode possible) 
%   track_map                   trackmap as table or matrix
%
% Out:
%   track_element_index         index of the current track element, corresponding to the given track map 
%

%% Initialization and checks

% % Conversion from 'track_map' in table format to matrix format, because of
% % performance issues!
% [track_map,track_ids,track_elements,track_radii,track_lengths,track_speed_limits] = tableTrackMap2matTrackMap(track_map);

track_element_index = zeros(1,length(track_map_abs_position));

%% Calculations

[track_element_starting_points,~] = getTrackElementEndPoints(1:size(track_map,1),track_map);

for i = 1:length(track_map_abs_position)
    current_rel_position = track_map_abs_position(i);
    
    current_track_element_index = find(current_rel_position >= track_element_starting_points(1:end),1,'last');
    if isempty(current_track_element_index)
        current_track_element_index = 1;
    end % if
    
    track_element_index(i) = current_track_element_index;
end % for i

end

