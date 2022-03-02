function [track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit] = calcMapPropertiesFast(map,map_density)
% [track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit] = calcMapPropertiesFast(map,map_density)

%% Checks

if any(isnan(map.track_start_points.x_0)) 
    error('calcMapPropertiesFast: Start point for each track needed!')
end % if

if ~all(ismember(map.track_maps.ID,map.track_start_points.ID)) ... 
        || ... 
        (length(map.track_maps.ID) ~= length(map.track_start_points.ID))
    error('calcMapPropertiesFast: Start point for each track element needed!')
end % if

%% Calculations

track_id = [];
track_rel_position = [];
abs_position = [];
orientation = [];
curvature = [];
radius = [];
speed_limit = [];
for track_i = 1:length(map.track_start_points.ID)
    % waitbarStatus(track_i,length(map.track_start_points.ID),5);
    
    track_start_point_i = map.track_start_points(track_i,:);
    track_i_id = track_start_point_i.ID;
    track_i_p_0 = [track_start_point_i.x_0;track_start_point_i.y_0];
    track_i_phi_0 = track_start_point_i.phi_0;
    
    track_map_i_selector = (map.track_maps.ID==track_i_id);
    track_map_i = map.track_maps(track_map_i_selector,:); 
    r_start_i = track_map_i.r_start;
    r_end_i = track_map_i.r_end;
    L_i = track_map_i.length;
    speed_limit_i = track_map_i.speed_limit;
    element_i = track_map_i.track_element;
    d_i = unique([0:map_density:L_i,L_i]);
    
    switch element_i
        case 1
            [c_n,t_n,curv_n,radius_n] = straightLineTrackElement(d_i,track_i_phi_0,track_i_p_0);
        case 3
            [c_n,t_n,curv_n,radius_n] = constantArcTrackElement(d_i,r_start_i,track_i_phi_0,track_i_p_0);
        case {2,4,5}
            [c_n,t_n,curv_n,radius_n] = clothoidTrackElement(d_i,L_i,r_start_i,r_end_i,track_i_phi_0,track_i_p_0);
        otherwise
            % error('calcMapPropertiesFast: Unsopported track-element type!')
            continue
    end % switch
    
    track_id = [track_id,track_i_id];
    track_rel_position = [track_rel_position,d_i,nan];
    abs_position = [abs_position,c_n,nan(2,1)];
    orientation = [orientation,t_n,nan(2,1)];
    curvature = [curvature,curv_n,nan];
    radius = [radius,radius_n,nan];
    speed_limit = [speed_limit,speed_limit_i];
    
end % for i

end

