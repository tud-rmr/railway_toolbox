function [track_id,track_rel_position,track_map_index,abs_position,orientation,curvature,radius,speed_limit,route_track_map,updated_railway_map] = calcTrackRouteProperties(d_train,track_route,track_route_id_0,track_route_rel_position_0,railway_map,direction)
% [track_id,track_rel_position,track_map_index,abs_position,orientation,curvature,radius,speed_limit,route_track_map,updated_railway_map] = calcTrackRouteProperties(d_train,track_route,track_rel_position_0,railway_map,direction)
%
% In:
%   d_train                       the train's traveled distance in meters from starting point [track_id_0,track_rel_position_0] (vector input possible)
%   track_route                   array with track-IDs the train is traveling
%   track_route_id_0              track ID of the track element where the train started
%   track_route_rel_position_0    distance in meters from starting point of the track element with ID 'track_id_0'
%   railway_map                   Railway-map as table or matrix
%   direction                     train direction relative to trackmap (forward --> 1; backward --> -1)
%
% Out:
%   ...                     See descriptions in 'calcTrackProperties' 
%   route_track_map         Trackmap of choosen route
%   updated_railway_map     Updated railway map

%% Initialization and checks

% Convert 'railway_map.track_maps' to cell array
[~,track_starting_points_ids,~,~,~,~] = tableTrackStartPoints2matTrackStartPoints(railway_map.track_start_points);
if ~iscell(railway_map.track_maps) && istable(railway_map.track_maps)    
    num_tracks = length(railway_map.topology);
    
    track_maps_temp = cell(num_tracks,1);
    mat_track_maps_temp = matTrackMap2tableTrackMap(railway_map.track_maps);   
    for i = 1:num_tracks
        current_track_id = track_starting_points_ids(i);        
        track_maps_selector = (mat_track_maps_temp.ID==current_track_id);

        if ~any(track_maps_selector)
            track_maps_temp{i} = matTrackMap2tableTrackMap(current_track_id);
        else
            track_maps_temp{i} = mat_track_maps_temp(track_maps_selector,:);
        end % if      
    end % for i    
    railway_map.track_maps = track_maps_temp;
elseif ~iscell(railway_map.track_maps) && ~istable(railway_map.track_maps)    
    error('calcTrackRouteProperties: Wrong type of ''railway_map.track_maps''!');
end % if

% Conversion from 'railway_map.track_maps' in table format to matrix format, because of performance issues!
for i = 1:length(track_starting_points_ids)
        [~,track_map_i_ids,~,~,~,~,~,~] = tableTrackMap2matTrackMap(railway_map.track_maps{i});

        if (length(unique(track_map_i_ids)) > 1)
            error('calcMapProperties: Trackmaps used in a railway-map have to have unique IDs within each trackmap!')
        end % if

        if track_starting_points_ids(i) ~= track_map_i_ids(1)
            error('calcMapProperties: Track-IDs between starting point and trackmap do not match!')
        end % if
end % for i

if ~any(track_starting_points_ids == track_route_id_0)
    error('Starting Track-ID not contained in given trackmap!');
end % if

if ~all(ismember(track_route,track_starting_points_ids))
    error('Track-IDs in ''track_route'' not contained in given railway-map!');
end % if

if nargin < 6
    direction = sign(d_train);
end % if

if ((length(direction) ~= length(d_train)) && (length(direction) ~= 1)) || min(size(direction)) > 1
    error('''direction'' has wrong length!');
end % if

if any(direction==0) && (any(diff(direction(direction~=0))) || all(direction(direction~=0)<0))
    warning('There is an entry with ''direction=0'', which is interpreted as positive direction.');    
end % if

if length(direction) == 1
    direction = repmat(direction,length(d_train),1);
end % if

%% Calculations

% Calculate starting points of not provided in the given railway-map
[~,railway_map] = calcTableTrackStartPoints([],railway_map);

% Build trackmap of given route
track_route_index = ismember(railway_map.track_start_points.ID,track_route);
track_map_sizes = cellfun(@(cell) size(cell,1),railway_map.track_maps(track_route_index));
track_map_upper_indices = cumsum(track_map_sizes);
track_map_lower_indices = [1; track_map_upper_indices(2:end)-track_map_sizes(2:end)+1];

route_track_map = repmat(matTrackMap2tableTrackMap(),sum(track_map_sizes),1);
for i = 1:length(track_route)
    railway_map_index = ismember(railway_map.track_start_points.ID,track_route(i));
    route_track_map(track_map_lower_indices(i):track_map_upper_indices(i),:) = railway_map.track_maps{railway_map_index};
end % for i

% Get trackmap start point
track_map_start_point = railway_map.track_start_points(find(track_route_index,1,'first'),:);
track_map_rot_angle = track_map_start_point.phi_0;
track_map_p_0 = [track_map_start_point.x_0;track_map_start_point.y_0];

% Output __________________________________________________________________

% Calculate properties
[track_id,track_rel_position,track_map_index,abs_position,orientation,curvature,radius,speed_limit] = calcTrackProperties(d_train,track_route_id_0,track_route_rel_position_0,route_track_map,track_map_rot_angle,direction);
abs_position = round((abs_position + track_map_p_0)*1e3)/1e3;

if any(isnan(track_map_p_0)) || any(isnan(track_map_rot_angle))
    error('calcMapProperties: Could not evaluate function because there are some tracks without a start point!');
end % if

updated_railway_map = railway_map;

end % end function


