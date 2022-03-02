function [updated_track_start_point,updated_track_start_point_cov,updated_track_start_points,updated_track_start_points_cov] = calcMatTrackStartPoints(track_id,topology,track_start_points,track_maps,track_start_points_cov,track_maps_cov)
% [updated_track_start_point,updated_track_start_point_cov,updated_track_start_points,updated_track_start_points_cov] = calcMatTrackStartPoints(track_id,topology,track_start_points,track_maps,track_start_points_cov,track_maps_cov)
%
% In:
%   track_id                    Tracks for which the starting point should be calculated (array mode possible).
%                               If it is empty, the starting points are calculated for all possible tracks.
%   topology                    Topology of the railway map as matrix
%   track_start_points          all track-start-points as table or matrix
%   track_maps                  all trackmaps as table or matrix, stored in a cell vector.
%   track_start_points_cov      covariance matrices for all track-start-points (only necessary when start points are given in matrix format)
%   track_maps_cov              covariance matrices for all trackmaps, stored in a cell vector (only necessary when start points are given in matrix format)
%
% Out:
%   updated_track_start_point       track start points corresponding to the input 'track_id'
%   (not implemented yet) --> updated_track_start_point_cov   covariance matrices corresponding to 'updated_track_start_point' (cell vector)
%   updated_track_start_points      all track start points as matrix
%   (not implemented yet) --> updated_track_start_points_cov  all corresponding covariance matrices (cell vector)
%

updated_track_start_points = track_start_points;
updated_track_start_points_cov = track_start_points_cov;

[updated_track_start_point,updated_track_start_point_cov,updated_track_start_points,updated_track_start_points_cov] = calcMatTrackStartPoints_InnerFcn(track_id,topology,updated_track_start_points,track_maps,updated_track_start_points_cov,track_maps_cov);
num_nans_memory = sum(isnan(updated_track_start_points(:)));
num_nans = max(num_nans_memory-1,1);
while num_nans < num_nans_memory
    [updated_track_start_point,updated_track_start_point_cov,updated_track_start_points,updated_track_start_points_cov] = calcMatTrackStartPoints_InnerFcn(track_id,topology,updated_track_start_points,track_maps,updated_track_start_points_cov,track_maps_cov);
    
    num_nans_memory = num_nans;
    num_nans = sum(isnan(updated_track_start_points(:)));
end 

end % function

function [updated_track_start_point,updated_track_start_point_cov,updated_track_start_points,updated_track_start_points_cov] = calcMatTrackStartPoints_InnerFcn(track_id,topology,track_start_points,track_maps,track_start_points_cov,track_maps_cov)
% [updated_track_start_point,updated_track_start_point_cov,updated_track_start_points,updated_track_start_points_cov] = calcMatTrackStartPoints_InnerFcn(track_id,topology,track_start_points,track_maps,track_start_points_cov,track_maps_cov)
%
% In:
%   track_id                    Tracks for which the starting point should be calculated (array mode possible).
%                               If it is empty, the starting points are calculated for all possible tracks.
%   topology                    Topology of the railway map as matrix
%   track_start_points          all track-start-points as table or matrix
%   track_maps                  all trackmaps as table or matrix, stored in a cell vector.
%   track_start_points_cov      covariance matrices for all track-start-points (only necessary when start points are given in matrix format)
%   track_maps_cov              covariance matrices for all trackmaps, stored in a cell vector (only necessary when start points are given in matrix format)
%
% Out:
%   updated_track_start_point       track start points corresponding to the input 'track_id'
%   (not implemented yet) --> updated_track_start_point_cov   covariance matrices corresponding to 'updated_track_start_point' (cell vector)
%   updated_track_start_points      all track start points as matrix
%   (not implemented yet) --> updated_track_start_points_cov  all corresponding covariance matrices (cell vector)
%

%% Initialization and checks

% Conversion from 'track_start_points' in table format to matrix format, because of performance issues!
if nargin < 5 % table input assumed
    [track_start_points,track_start_points_ids,track_x0s,track_y0s,track_phi0s,track_start_points_cov] = tableTrackStartPoints2matTrackStartPoints(track_start_points);
else % matrix input assumed
    [track_start_points,track_start_points_ids,track_x0s,track_y0s,track_phi0s,~] = tableTrackStartPoints2matTrackStartPoints(track_start_points);
end % if

% Convert 'railway_map.track_maps' to cell array
if ~iscell(track_maps) && istable(track_maps)    
    num_tracks = length(topology);
    
    track_maps_temp = cell(num_tracks,1);
    mat_track_maps_temp = matTrackMap2tableTrackMap(track_maps);   
    for i = 1:num_tracks
        current_track_id = track_start_points_ids(i);        
        track_maps_selector = (mat_track_maps_temp.ID==current_track_id);

        if ~any(track_maps_selector)
            track_maps_temp{i} = matTrackMap2tableTrackMap(current_track_id);
        else
            track_maps_temp{i} = mat_track_maps_temp(track_maps_selector,:);
        end % if      
    end % for i    
    track_maps = track_maps_temp;
elseif ~iscell(track_maps) && ~istable(track_maps)    
    error('calcMatTrackStartPoints: Wrong type of ''railway_map.track_maps''!');
end % if

% Conversion from 'track_maps' in table format to matrix format, because of performance issues! 
track_maps_cell_array = cell(size(track_start_points,1),1);
track_maps_cov_cell_array = cell(size(track_start_points,1),1);
for i = 1:size(track_maps,1)
    [track_maps_cell_array{i,1},~,~,~,~,~,~,track_maps_cov_cell_array{i,1}] = tableTrackMap2matTrackMap(track_maps{i});
end % for i
track_maps = track_maps_cell_array;
if nargin < 5 % table input assumed
    track_maps_cov = track_maps_cov_cell_array;
end % if

% If no special track ID is given do search for all possible tracks
if isempty(track_id)
    track_id = track_start_points_ids;
end % if

% Check on right number of input arguments
if nargin == 5
    error('calcTrackStartPoints: You have to provide ''track_start_points_cov'' and ''track_maps_cov''!');
end % if

% Check track ID consistency
if ~any(ismember(track_start_points_ids,track_id))
    error('calcTrackStartPoints: Track ID not contained in thre given railway map!');
end % if

% Table names for track-start-points
[~,track_start_points_table_variable_names] = orderTableTrackStartPoints([]);

% Output variables initialization
updated_track_start_points = track_start_points;
updated_track_start_points_cov = track_start_points_cov;

%% Calculations

% Create lists for tracks with starting point and without _________________
track_starting_point_status = arrayfun( @(arr) isnan(arr), ... 
                                        track_x0s        ... 
                                        .*               ... 
                                        track_y0s        ... 
                                        .*               ... 
                                        track_phi0s      ... 
                                      );                                        
tracks_without_starting_point_index = track_starting_point_status;
tracks_with_starting_point_index = find(~track_starting_point_status);
% tracks_with_starting_point_index = ~track_starting_point_status;

% Assign starting points to tracks ________________________________________
for track_id_index = 1:length(track_id)
    track_id_i = track_id(track_id_index);
    track_i_index = (track_start_points_ids==track_id_i);
        
    % 1) No start point given for current track ___________________________
    if any(track_start_points_ids(tracks_without_starting_point_index) == track_id_i)        
        % Find preceding tracks for 'track_id_index'
        preceding_tracks_index = find(topology(:,track_i_index));
        succeeding_tracks_index = find(topology(track_i_index,:));
                
        % Get end point of preceding tracks (recursion)
        track_j_start_point = [NaN;NaN];
        track_j_phi_start = NaN;
        for track_j_index = preceding_tracks_index(:)'
            track_j_id = track_start_points_ids(track_j_index);
            %track_j_start_point_cov = track_start_points_cov(track_j_index);
            [~,~,updated_track_start_points,~] = calcMatTrackStartPoints_InnerFcn(track_j_id,topology,updated_track_start_points,track_maps,updated_track_start_points_cov,track_maps_cov);
            
            % Conversion from 'track_start_points' into seperate matrices
            [~,~,track_j_x0,track_j_y0,track_j_phi0,~] = tableTrackStartPoints2matTrackStartPoints(updated_track_start_points(track_j_index,:));
                        
            % Start point of preceding track found
            if ~isnan(track_j_x0.*track_j_y0.*track_j_phi0)
                % Conversion from 'track_maps' into seperate matrices               
                [track_map_j,track_ids_j,~,~,~,track_lengths_j,~,~] = tableTrackMap2matTrackMap(track_maps{track_j_index});
                                
                [~,~,~,track_j_start_point,track_j_orientation,~,~,~] = calcTrackProperties(sum(track_lengths_j),track_ids_j(1),0,track_map_j,track_j_phi0,1);
                track_j_start_point = track_j_start_point + [track_j_x0;track_j_y0];
                track_j_phi_start = atan2d(track_j_orientation(2,1),track_j_orientation(1,1));

                break;
            end % if
        end % for track_j_index
        
        % Get start points of succeeding tracks (recursion)
        if any(isnan(track_j_start_point)) && any(ismember(tracks_with_starting_point_index(:),succeeding_tracks_index(:))) 
            for track_j_index = succeeding_tracks_index(:)'
                track_j_id = track_start_points_ids(track_j_index);
                %track_j_start_point_cov = track_start_points_cov(track_j_index);
                [~,~,updated_track_start_points,~] = calcMatTrackStartPoints_InnerFcn(track_j_id,topology,updated_track_start_points,track_maps,updated_track_start_points_cov,track_maps_cov);

                % Conversion from 'track_start_points' into seperate matrices
                [~,~,track_j_x0,track_j_y0,track_j_phi0,~] = tableTrackStartPoints2matTrackStartPoints(updated_track_start_points(track_j_index,:));

                % Start point of succeeding track found
                if ~isnan(track_j_x0.*track_j_y0.*track_j_phi0)
                    track_map_tmp = matTrackMap2tableTrackMap(track_maps{track_i_index});                    
                    
                    % Invert Direction of track-map
                    track_map_tmp = flipud(track_map_tmp);
                    
                    if any(track_map_tmp.track_element == 2)
                        clothoid_selector = (track_map_tmp.track_element==2);                        
                        track_map_tmp.track_element(clothoid_selector,:) = 4;
                    elseif any(track_map_tmp.track_element == 4)
                        clothoid_selector = (track_map_tmp.track_element==4);                        
                        track_map_tmp.track_element(clothoid_selector,:) = 2;
                    end % if     
                    track_map_tmp.r_end = track_map_tmp.r_end * (-1);
                    track_j_phi0 = atan2d(-1*sind(track_j_phi0),-1*cosd(track_j_phi0));
                                        
                    % Conversion from 'track_maps' into seperate matrices
                    [track_map_j,track_ids_j,~,~,~,track_lengths_j,~,~] = tableTrackMap2matTrackMap(track_map_tmp);

                    [~,~,~,track_j_start_point,track_j_orientation,~,~,~] = calcTrackProperties(sum(track_lengths_j),track_ids_j(1),0,track_map_j,track_j_phi0,1);
                    track_j_start_point = [track_j_x0;track_j_y0]+track_j_start_point;
                    track_j_phi_start = atan2d(-1*track_j_orientation(2),-1*track_j_orientation(1));

                    break;
                end % if
                
            end % end for track_j_index
        end % if

        % Output
        updated_track_start_points(track_i_index,strcmp(track_start_points_table_variable_names,'ID')) = track_id_i;
        updated_track_start_points(track_i_index,strcmp(track_start_points_table_variable_names,'x_0')) = round(track_j_start_point(1,1)*1e3)/1e3;
        updated_track_start_points(track_i_index,strcmp(track_start_points_table_variable_names,'y_0')) = round(track_j_start_point(2,1)*1e3)/1e3;
        updated_track_start_points(track_i_index,strcmp(track_start_points_table_variable_names,'phi_0')) = round(track_j_phi_start*1e9)/1e9;
        
    % 2) Start point available for current rack ___________________________
    % else any(track_ids(tracks_with_starting_point_index) == track_id(track_id_index))         
    %    % Do nothing (everything done through the initialization)  
    
    end % if

end % for track_id_index

% Output
updated_track_start_point = updated_track_start_points(ismember(track_start_points_ids,track_id),:);
updated_track_start_point_cov = updated_track_start_points_cov(ismember(track_start_points_ids,track_id));

end % function

