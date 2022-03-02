function [track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit,updated_railway_map] = calcMapProperties(railway_map,resolution)
% [track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit,updated_railway_map] = calcMapProperties(railway_map,resolution)
%
% In:
%   railway_map             Railway-map as table or matrix
%   resolution              distance between track-points being calculated
%
% Out:
%   ...                     See descriptions in 'calcTrackProperties' 
%   updated_railway_map     Updated railway map

%% Initialization and checks

% Check if fast calculation is possible
if all(~isnan(railway_map.track_start_points.x_0)) ...
   && ...
   all(ismember(railway_map.track_maps.ID,railway_map.track_start_points.ID)) ...
   && ...
   length(railway_map.track_maps.ID) == length(railway_map.track_start_points.ID)
    
	fprintf('Calculating Railway-Map Properties (density %.2fm)...',resolution);
	
    [track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit] = calcMapPropertiesFast(railway_map,resolution);
    updated_railway_map = railway_map;
	
	fprintf('done!\n');
    
    return
end % if

% Conversion from 'track_start_points' in table format to matrix format, because of performance issues!
if istable(railway_map.track_start_points)
    [~,track_start_points_ids,~,~,~,~] = tableTrackStartPoints2matTrackStartPoints(railway_map.track_start_points);
else
    [~,track_start_points_ids,~,~,~,~] = tableTrackStartPoints2matTrackStartPoints(railway_map.track_start_points);
end % if

% Convert 'railway_map.track_maps' to cell array
if ~iscell(railway_map.track_maps) && istable(railway_map.track_maps)    
    num_tracks = length(railway_map.topology);
    
    track_maps_temp = cell(num_tracks,1);
    mat_track_maps_temp = matTrackMap2tableTrackMap(railway_map.track_maps);   
    for i = 1:num_tracks
        current_track_id = track_start_points_ids(i);        
        track_maps_selector = (mat_track_maps_temp.ID==current_track_id);

        if ~any(track_maps_selector)
            track_maps_temp{i} = matTrackMap2tableTrackMap(current_track_id);
        else
            track_maps_temp{i} = mat_track_maps_temp(track_maps_selector,:);
        end % if      
    end % for i    
    railway_map.track_maps = track_maps_temp;
elseif ~iscell(railway_map.track_maps) && ~istable(railway_map.track_maps)    
    error('calcMapProperties: Wrong type of ''railway_map.track_maps''!');
end % if

%% Calculations

fprintf('\nCalculating Railway-Map Properties (density %.2fm) \n',resolution);

track_id = [];
track_rel_position = [];
abs_position = [];
orientation = [];
curvature = [];
radius = [];
speed_limit = [];

track_ids = track_start_points_ids;
for i = 1:size(railway_map.track_maps,1)
    d_train = 0:resolution:sum(railway_map.track_maps{i}.length);
    [track_id_temp,track_rel_position_temp,~,abs_postion_temp,orientation_temp,curvatur_temp,radius_temp,speed_limit_temp,~,updated_railway_map] = calcTrackRouteProperties(d_train,track_ids(i),track_ids(i),0,railway_map,1);
    
    track_id = [track_id track_id_temp NaN(size(track_id_temp,1),1)];
    track_rel_position = [track_rel_position track_rel_position_temp NaN(size(track_rel_position_temp,1),1)];
    abs_position = [abs_position abs_postion_temp NaN(size(abs_postion_temp,1),1)];
    orientation = [orientation orientation_temp NaN(size(orientation_temp,1),1)];
    curvature = [curvature curvatur_temp NaN(size(curvatur_temp,1),1)];
    radius = [radius radius_temp NaN(size(radius_temp,1),1)];
    speed_limit = [speed_limit speed_limit_temp NaN(size(speed_limit_temp,1),1)];
	
	waitbarStatus(i,size(railway_map.track_maps,1),5);
end % for i

% fprintf('\n');

end % end function


