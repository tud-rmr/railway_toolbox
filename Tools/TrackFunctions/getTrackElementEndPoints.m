function [track_element_starting_point,track_element_ending_point] = getTrackElementEndPoints(track_element,track_map)
% [track_element_starting_point,track_element_ending_point] = getTrackElementEndPoints(track_id,track_map)
%
% In:
%   track_element   track element index, corresponding to the given trackmap (array mode possible)
%   track_map       trackmap as table or matrix
%
% Out:
%   track_element_starting_point    starting point in meters relative to the trackmap
%   track_element_ending_point      ending point in meters relative to the trackmap
%

%% Initialization and checks

% Conversion from 'track_map' in table format to matrix format, because of
% performance issues!
[track_map,~,~,~,~,track_lengths,~,~] = tableTrackMap2matTrackMap(track_map);

if min(size(track_element)) > 1
    error('''track_element'' has to be a vector!');
end % if

if size(track_element,2) == 1
    track_element = track_element';
end % if

if any(track_element > size(track_map,1)) || any(track_element < 1)
    error('Track element not contained in given trackmap!');
end % if

%% Calculations

% Calculate start points
track_element_sections = [0;cumsum(track_lengths)];
track_element_starting_point = track_element_sections(track_element)';

% Calculate end points
track_element_ending_point = zeros(1,length(track_element));
for track_element_index = 1:length(track_element)
    track_element_ending_point(track_element_index) = track_element_starting_point(track_element_index) + track_lengths(track_element(track_element_index));
end % for

end % function

