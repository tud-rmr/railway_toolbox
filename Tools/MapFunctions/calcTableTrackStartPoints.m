function [updated_track_start_point,updated_railway_map] = calcTableTrackStartPoints(track_id,railway_map)
% [updated_track_start_point,updated_railway_map] = calcTableTrackStartPoints(track_id,railway_map)
%
% In:
%   track_id        Tracks for which the starting point should be calculated (array mode possible).
%                   If it is empty, the starting points are calculated for all possible tracks.
%   railway_map     Railway-map as table or structure
%
% Out:
%   updated_track_start_point       track start points corresponding to the input 'track_id'
%   updated_railway_map             updated railway-map with calculated starting points
%   (not implemented yet) --> updated_track_start_points_cov  all corresponding covariance matrices (cell vector)
%

%% Initialization and checks

% Strip railway-map
topology = railway_map.topology;
track_start_points = railway_map.track_start_points;
track_maps = railway_map.track_maps;
if isstruct(railway_map.track_start_points)
    track_start_points_cov = {railway_map.track_start_points.cov};
    track_start_points_cov = track_start_points_cov(:);
else
    track_start_points_cov = railway_map.track_start_points.cov;
end % if

if iscell(track_maps)        
    track_maps_cov = cellfun(@(cell) cell.cov,railway_map.track_maps(:),'UniformOutput',0);
else
    track_maps_cov = railway_map.track_maps.cov;
end % if

% Table names for track-start-points
[~,track_start_points_table_variable_names] = orderTableTrackStartPoints([]);

% Output initialization
updated_railway_map = railway_map;

%% Calculations

% Calculate with matrices because of performance issues with table format
[mat_track_start_point,mat_track_start_point_cov,mat_track_start_points,cell_track_start_points_cov] = calcMatTrackStartPoints(track_id,topology,track_start_points,track_maps,track_start_points_cov,track_maps_cov);

% Output
updated_railway_map.track_start_points = array2table(mat_track_start_points,'VariableNames',track_start_points_table_variable_names);
updated_railway_map.track_start_points.cov = cell_track_start_points_cov;
updated_track_start_point = array2table(mat_track_start_point,'VariableNames',track_start_points_table_variable_names);
updated_track_start_point.cov = mat_track_start_point_cov;

end % function

