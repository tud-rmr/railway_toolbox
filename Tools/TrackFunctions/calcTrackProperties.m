function [track_id,track_rel_position,track_map_index,abs_position,orientation,curvature,radius,speed_limit] = calcTrackProperties(d_train,track_id_0,track_rel_position_0,track_map,track_map_rot_angle,direction)
% [track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit]  = calcTrackProperties(d_train,track_id_0,track_rel_position_0,track_map,track_map_rot_angle,direction)
%
% In:
%   d_train                 the train's traveled distance in meters from starting point [track_id_0,track_rel_position_0] (vector input possible)
%   track_id_0              track ID of the track element where the train started
%   track_rel_position_0    distance in meters from starting point of the track element with ID 'track_id_0'
%   track_map               trackmap as table
%   track_map_rot_angle     rotation of the trackmap in degree at the origin 
%   direction               train direction relative to trackmap (forward --> 1; backward --> -1)
%
% Out:
%   track_id                track ID corresponding to the input values of'd_train', 'track_id_0' and 'track_rel_position_0' 
%   track_rel_position      position in meters relative to the current track ID, corresponding to the input values of'd_train', 'track_id_0' and 'track_rel_position_0' 
%   track_map_index         index/row of the track element in the track map
%   abs_position            absolute position (2D) in navigation coordinate system 
%   orientation             orientation vector (normalized to 1), representing the orientation of the track 
%   curvature               curvature in 1/m, representing the curvature of the track  
%   radius                  radius in m, representing the radius of the track (we define: if curvature=inf --> r=0)  
%   speed_limit             speed limit in km/h of the track 
%

%% Initialization and checks

% Conversion from 'track_map' in table format to matrix format, because of 
% performance issues!
[track_map,track_ids,track_elements,track_start_radii,track_end_radii,track_lengths,track_speed_limits,~] = tableTrackMap2matTrackMap(track_map);

if ~any(track_ids == track_id_0)
    error('calcTrackProperties: Track ID not contained in given trackmap!');
end % if

if nargin < 5 || isempty(track_map_rot_angle)
    track_map_rot_angle = 0;
end % if

if nargin < 6 || isempty(direction)
    direction = sign(d_train);
end % if

if ((length(direction) ~= length(d_train)) && (length(direction) ~= 1)) || min(size(direction)) > 1
    error('calcTrackProperties: ''direction'' has wrong length!');
end % if

if any(direction==0) && (any(diff(direction(direction~=0))) || all(direction(direction~=0)<0))
    warning('There is an entry with ''direction=0'', which is interpreted as positive direction.');    
end % if

if length(direction) == 1
    direction = repmat(direction,length(d_train),1);
end % if

% Output variables initialization
track_id = zeros(1,length(d_train));
track_rel_position = zeros(1,length(d_train));
track_map_index = zeros(1,length(d_train));
abs_position = zeros(2,length(d_train));
orientation = zeros(2,length(d_train));
curvature = zeros(1,length(d_train));
radius = zeros(1,length(d_train));
speed_limit = zeros(1,length(d_train));

rotation_matrix = @(phi) [cosd(phi) -sind(phi);sind(phi) cosd(phi)];

%% Calculations

track_map_abs_train_positions = calcTrackAbsTrainPosition(d_train,track_id_0,track_rel_position_0,track_map,direction);
[track_element_start_lengths,~] = getTrackElementEndPoints(1:size(track_map,1),track_map);  
track_element_indices = getTrackElementIndex(track_map_abs_train_positions,track_map); 
[track_element_ids,track_rel_positions,element_rel_positions] = getTrackRelPosition(track_map_abs_train_positions,track_map);

for d_train_index = 1:length(d_train)
 
    current_track_element_index = track_element_indices(d_train_index); 
    current_track_element_direction = direction(d_train_index);
    current_track_id = track_element_ids(d_train_index);
    current_track_rel_position = track_rel_positions(d_train_index);
    current_track_element_rel_position = element_rel_positions(d_train_index);
    
    current_track_element_start_length = track_element_start_lengths(current_track_element_index);     
    
    % Recursivly calculate absolute starting point and orientation  for each 
    % track element _______________________________________________________
    if current_track_element_index > 1
        [~,~,~,p_before,t_before] = calcTrackProperties(current_track_element_start_length,track_ids(1),0,track_map(1:current_track_element_index-1,:),[],current_track_element_direction);
        c_last_element = p_before;
        phi_last_element = atan2d(t_before(2,end),t_before(1,end));        
    else
        phi_last_element = 0;
        c_last_element = [0;0];
    end % if    
   
    % Calculate position and orientation vector ___________________________
    switch track_elements(current_track_element_index)
        case 1
            [c_n,t_n,curv_n,radius_n] = straightLineTrackElement(current_track_element_rel_position,phi_last_element,c_last_element);
        case 2
            [c_n,t_n,curv_n,radius_n] = clothoidTrackElement(current_track_element_rel_position,track_lengths(current_track_element_index),track_start_radii(current_track_element_index),track_end_radii(current_track_element_index),phi_last_element,c_last_element);
        case 3
            [c_n,t_n,curv_n,radius_n] = constantArcTrackElement(current_track_element_rel_position,track_end_radii(current_track_element_index),phi_last_element,c_last_element);
        case 4
            [c_n,t_n,curv_n,radius_n] = clothoidTrackElement(current_track_element_rel_position,track_lengths(current_track_element_index),track_start_radii(current_track_element_index),track_end_radii(current_track_element_index),phi_last_element,c_last_element);
        case 5
            [c_n,t_n,curv_n,radius_n] = clothoidTrackElement(current_track_element_rel_position,track_lengths(current_track_element_index),track_start_radii(current_track_element_index),track_end_radii(current_track_element_index),phi_last_element,c_last_element);
        otherwise
            % warning('calcTrackProperties: Track geometry unkonw!');
            c_n = [NaN;NaN];
            t_n = [NaN;NaN];
            curv_n = NaN;
            radius_n = NaN;
    end % switch
    
    % Output ______________________________________________________________
    track_id(d_train_index) = current_track_id;
    track_rel_position(d_train_index) = current_track_rel_position;
    track_map_index(d_train_index) = current_track_element_index;
    abs_position(:,d_train_index) = rotation_matrix(track_map_rot_angle) * c_n;
    orientation(:,d_train_index) = rotation_matrix(track_map_rot_angle) * t_n;
    curvature(d_train_index) = curv_n;
    radius(d_train_index) = radius_n;
    speed_limit(d_train_index) = track_speed_limits(current_track_element_index);
    
%     if direction(l_index) < 0
%         orientation(:,l_index) = orientation(:,l_index);
%         curvature(1,l_index) = curvature(1,l_index);
%     end % if
    
end % for

end % function

function track_map_abs_train_position = calcTrackAbsTrainPosition(d_train,track_id_0,track_rel_position_0,track_map,direction)
%% Initialization and checks

% Conversion from 'track_map' in table format to matrix format, because of
% performance issues!
[track_map,~,~,~,~,~,~,~] = tableTrackMap2matTrackMap(track_map);

% Initialize output variables
track_id = zeros(1,length(d_train));
track_map_abs_train_position = zeros(1,length(d_train));
track_element_index = zeros(1,length(d_train));

%% Calculations

% Transform start point of the train from track element relative 
% coordinates (track_id_0,track_rel_position_0) to trackmap relative 
% coordinates (distance measured from the first track element in the map)
train_start_abs_length = getTrackAbsPosition(track_id_0,track_rel_position_0,track_map);

% Calculate current position relative to the given trackmap
for d_train_index = 1:length(d_train)       
    if direction(d_train_index) < 0 % train is driving against track counting direction
        current_abs_length = train_start_abs_length - abs(d_train(d_train_index));
    else % train is driving in track counting direction
        current_abs_length = train_start_abs_length + abs(d_train(d_train_index));
    end       
    
    % current_track_element_index = getTrackElementIndex(current_abs_length,track_map);
        
    % track_id(d_train_index) = track_ids(current_track_element_index);
    track_map_abs_train_position(d_train_index) = current_abs_length;
    % track_element_index(d_train_index) = current_track_element_index;    
end % for

end % function
