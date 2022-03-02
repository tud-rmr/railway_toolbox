function [track_end_point,updated_railway_map] = calcTrackEndPoints(railway_map,track_id)
% [track_end_point,updated_railway_map] = calcTrackEndPoints(railway_map,track_id)
%
% In:
%   railway_map     railway-map as table
%   track_id        track for which the ending point should be calculated (array mode possible)
%
% Out:
%   track_end_point     the track's end point as table
%   updated_railway_map railway-map with updated starting points, which were calculated within this function, too
%

%% Initialization and checks

% Conversion from 'track_start_points' in table format to matrix format, because of performance issues!
[~,track_ids,track_x0s,track_y0s,track_phi0s,~] = tableTrackStartPoints2matTrackStartPoints(railway_map.track_start_points);

% Convert 'railway_map.track_maps' to cell array
if ~iscell(railway_map.track_maps) && istable(railway_map.track_maps)    
    num_tracks = length(railway_map.topology);
    
    track_maps_temp = cell(num_tracks,1);
    mat_track_maps_temp = matTrackMap2tableTrackMap(railway_map.track_maps);   
    for i = 1:num_tracks
        current_track_id = track_ids(i);        
        track_maps_selector = (mat_track_maps_temp.ID==current_track_id);

        if ~any(track_maps_selector)
            track_maps_temp{i} = matTrackMap2tableTrackMap(current_track_id);
        else
            track_maps_temp{i} = mat_track_maps_temp(track_maps_selector,:);
        end % if      
    end % for i    
    railway_map.track_maps = track_maps_temp;
elseif ~iscell(railway_map.track_maps) && ~istable(railway_map.track_maps)    
    error('calcTrackEndPoints: Wrong type of ''railway_map.track_maps''!');
end % if

if nargin == 1
    track_id = track_ids;
end % if

if ~any(ismember(track_id,track_ids))
    error('calcTrackEndPoints: Track ID not contained in thre given railway map!');
end % if

% Output variables initialization
track_end_point = array2table([track_id nan([length(track_id) 3])],'VariableNames',{'ID','x_end','y_end','phi_end'});
updated_railway_map = railway_map;

%% Calculations

% Create lists for tracks with starting point and without _________________
tracks_without_starting_point_index = arrayfun( @(arr) isnan(arr), ... 
                                                track_x0s        ... 
                                                .*               ... 
                                                track_y0s        ... 
                                                .*               ... 
                                                track_phi0s      ... 
                                              );                                        
track_without_starting_point_ids = updated_railway_map.track_start_points.ID(tracks_without_starting_point_index);

% Calculate starting points for all track without one, if possible
[~,updated_railway_map] = calcTableTrackStartPoints(track_without_starting_point_ids,updated_railway_map);

for track_id_index = 1:length(track_id)
    track_i_end_point = track_end_point(track_id_index,:);  
    track_i_id = track_id(track_id_index);
    railway_map_index = (track_ids==track_i_id);
         
   % 1) Try to adopt from end point from succeeding track _________________
         
    % Find succeeding tracks for 'track_id_index'
    succeeding_tracks_index = find(updated_railway_map.topology(railway_map_index,:));
        
    if any(succeeding_tracks_index)
        for track_j_index = succeeding_tracks_index(:)'
            track_j_id = track_ids(track_j_index);
            [track_j_start_point,updated_railway_map] = calcTableTrackStartPoints(track_j_id,updated_railway_map);

            % Start point of succeeding track exists
            if ~isnan(track_j_start_point.x_0.*track_j_start_point.y_0.*track_j_start_point.phi_0)
                track_i_end_point.x_end = track_j_start_point.x_0;
                track_i_end_point.y_end = track_j_start_point.y_0;
                track_i_end_point.phi_end = track_j_start_point.phi_0;
                break;
            end % if
        end % for track_j_index
    end % if
    
    % 2) Calculate end point from track properties and start point ________
    
    if any(isnan(track_i_end_point.Variables))
        track_map_i = updated_railway_map.track_maps{railway_map_index};
        track_i_length = sum(track_map_i.length);
        track_i_x_0 = updated_railway_map.track_start_points(railway_map_index,:).x_0;
        track_i_y_0 = updated_railway_map.track_start_points(railway_map_index,:).y_0;
        track_i_phi = updated_railway_map.track_start_points(railway_map_index,:).phi_0;        

        [~,~,~,track_i_abs_pos,track_i_orientation,~,~,~] = calcTrackProperties(track_i_length,track_map_i.ID(1),0,track_map_i,track_i_phi,1);
        
        track_i_end_point.x_end = round((track_i_abs_pos(1,1) + track_i_x_0)*10^3)/10^3;
        track_i_end_point.y_end = round((track_i_abs_pos(2,1) + track_i_y_0)*10^3)/10^3;
        track_i_end_point.phi_end = round(atan2d(track_i_orientation(2,1),track_i_orientation(1,1))*10^9)/10^9;
    end % if
    
    % Output ______________________________________________________________
    track_end_point(track_id_index,:) = track_i_end_point;
    
end % for track_id_index

end % function

