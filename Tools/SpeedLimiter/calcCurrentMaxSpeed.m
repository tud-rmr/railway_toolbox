function v_max = calcCurrentMaxSpeed(track_id,track_rel_position,a_limits,v_train,track_map)
% v_max = calcCurrentMaxSpeed(track_id,track_rel_position,a_limits,v_train,track_map)
%
% In:
%   track_id                track ID of the current track the train is on
%   track_rel_position      position of the train in meters, relative to the given track ID  
%   a_limits                acceleration limits in m/s^2 of the train ([max_decceleration max_acceleration]) 
%   v_train                 current train speed in m/s
%   track_map               trackmap as table or matrix
%
% Out:
%   v_max                   current max speed in m/s according to the given trackmap 
%

%% Initialization and Checks

% Conversion from 'track_map' in table format to matrix format, because of
% performance issues!
[track_map,~,~,~,~,track_lengths,track_speed_limits,~] = tableTrackMap2matTrackMap(track_map);

if any(track_rel_position<0)
    error('All ''track_rel_position'' have to be positive!');
end % if

if ~all(size(track_id) == size(track_rel_position))
    error('Dimension mismatch between ''track_ID'' and ''track_rel_position''!');
end % if

%% Calculations

if length(track_rel_position) > 1 % Recursion   
    
    v_max = zeros(length(track_rel_position),1);
    for i = 1:length(track_rel_position)
        current_track_id = track_id(i);
        current_rel_position = track_rel_position(i);
        v_max(i) = calcCurrentMaxSpeed(current_track_id,current_rel_position,a_limits,v_train,track_map);
    end % for i
    
else % Calculation for scalar track_rel_position
    
    % Auxiliary variables
    number_of_track_elements = size(track_map,1);
    [track_element_starting_point,~] = getTrackElementEndPoints(1:number_of_track_elements,track_map);
    track_abs_position = getTrackAbsPosition(track_id,track_rel_position,track_map);
    current_track_element_index = getTrackElementIndex(track_abs_position,track_map);
    
    % Create breaking map for relevant track sections at current speed    
    braking_map = zeros(length(track_lengths),3); % format: braking_map = [track_element_index, braking_point, speed_limit]
    for i = current_track_element_index:number_of_track_elements
        delta_v_i = v_train - track_speed_limits(i)/3.6;
        
        braking_map(i,1) = i; % track element index
        braking_map(i,2) = track_element_starting_point(i) - estimateBrakingDistance(v_train,delta_v_i,a_limits); % braking point
        braking_map(i,3) = track_speed_limits(i); % speed limit
    end % for i
    braking_map = braking_map(current_track_element_index:number_of_track_elements,:);
       
    % Output
    v_max = min(braking_map((track_abs_position >= braking_map(:,2)),3)) / 3.6;   

end % if

end % function
