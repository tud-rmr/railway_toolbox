function track_map = generateRndTrack(track_id,v_max,track_length,min_radius,num_track_elements)
% function track_map = generateRndTrack(track_id,v_max,track_length,min_radius,num_track_elements)
%
% In:
%   track_id as integer number
%   v_max in km/h
%   track_length in m
%   min_radius in m
%   num_track_elements as integer
%
% Out:
%   track_map as table
% 
% Track element types:
% -----|--------------------
%   #  | Type
% -----|--------------------
%   1  | straight
%   2  | normal clothoid
%   3  | circular arc
%   4  | reverse clothoid
%   5  | turn clothoid
%

%% Initialization and checks

if v_max <= 0
    error('''v_max'' has to be greater than zero!');
end % if

if num_track_elements <= 0
    error('''numTrackElements'' has to be greater than zero!');
end % if

if (length(track_id) > 1) || (length(v_max) > 1) || (length(track_length) > 1) || (length(min_radius) > 1) || (length(num_track_elements) > 1)
    error('One or more input arguments have a wrong length!');
end % if  

track_radii = zeros(num_track_elements,1);
track_speed_limits = zeros(num_track_elements,1);
track_element_lengths = zeros(num_track_elements,1);
track_elements = ones(num_track_elements,1);
track_cov = repmat({zeros(3)},length(track_elements),1);

%% Calculations

[~,r_max] = calcRadiusLimits(v_max,min_radius);  
radius_standard_deviation = 0.1 * r_max;
radius_mean = 0;
radius_pool = radius_standard_deviation .* randn(500,1) + radius_mean;
radius_pool = radius_pool(abs(radius_pool) >= min_radius);
track_lement_pool = [1,2];
for i = 1:num_track_elements    
    
    % Randomly choose track element / Set boundary conditions for next one
    track_elements(i) = track_lement_pool(randi(length(track_lement_pool)));
    
    if track_elements(i) == 1
        track_lement_pool = [1,2];
    elseif track_elements(i) == 2
        track_lement_pool = [3];
    elseif track_elements(i) == 3
        track_lement_pool = [4,5];
    elseif track_elements(i) == 4
        track_lement_pool = [1];
    elseif track_elements(i) == 5
        track_lement_pool = [3];
    end % if
    
    % Randomly choose a radius if necessary _______________________________
    if track_elements(i) == 2
        track_radii(i) = radius_pool(randi(length(radius_pool)));
    elseif any(ismember(track_elements(i),[3,4]))
        track_radii(i) = track_radii(i-1);
    elseif track_elements(i) == 5
        track_radii(i) = -1*track_radii(i-1);
    end % if
    
    % Define speed limits _________________________________________________
    if any(ismember(track_elements(i),[1,2,3,4]))
        r_track_i = track_radii(i);        
    elseif track_elements(i) == 5
        r_track_i = min(abs(track_radii(i)),abs(track_radii(i-1)));
    end
    track_speed_limits(i) = calcSpeedLimit(v_max,r_track_i);
    
    % Define minimum length for each track element ________________________
    track_element_lengths(i) = ... 
        calcMinimumTrackElementLength(track_elements(i),track_speed_limits(i),track_radii(i));
    
end % for i

% Distribute remaining length _____________________________________________

if track_length < sum(track_element_lengths)
    error('Track length too short! Retry or change track length.');
end % if

tracks_to_append = find(ismember(track_elements,[1,3]));
curvature_weight = 0.4; % [0 ... 1]
for i = 1:length(tracks_to_append)    
    track_index = tracks_to_append(i);
    
%     rest_length = max(0,L - sum(trackLength));
    if ismember(track_elements(track_index),[1])
        rest_length = max(0,(1-curvature_weight)*track_length - sum(track_element_lengths));
    elseif ismember(track_elements(track_index),[3])
        rest_length = max(0,curvature_weight*track_length - sum(track_element_lengths));
    end % if
    
    if i ~= length(tracks_to_append)
        random_part = randi([0 100]);    
        track_element_lengths(track_index) = track_element_lengths(track_index) + random_part/100*rest_length;
    else
        rest_length = max(0,track_length - sum(track_element_lengths));
        track_element_lengths(track_index) = track_element_lengths(track_index) + rest_length;
    end % if       
end % for i

% Create map ______________________________________________________________

track_map = table;
track_map.ID = repmat(track_id,length(track_elements),1);
track_map.track_element = track_elements;
track_map.r_end = track_radii;
track_map.r_start = track_radii;
track_map.r_start(track_elements==2) = 0;
track_map.r_end(track_elements==4) = 0;
track_map.r_start(track_elements==5) = track_radii(circshift((track_elements==5),-1));
track_map.length = track_element_lengths;
track_map.speed_limit = track_speed_limits;
track_map.cov = track_cov;

[track_map,~] = orderTableTrackMap(track_map);

end
