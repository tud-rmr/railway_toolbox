function [ordered_table_track_start_points,table_variables_names] = orderTableTrackStartPoints(table_track_start_points)
% [ordered_table_track_start_points,table_variables_names] = orderTableTrackStartPoints(table_track_start_points)
%
% In:
%   table_track_start_points             track-start-positions in table format
%
% Out:
%   ordered_table_track_start_points     ordered track-start-positions table
%   table_variables_names                names to which the track-start-positions table has been ordered
%

% Check input argument
if nargin == 0
    table_track_start_points = [];
end % if

% Define variables names and order
table_variables_names = {'ID','x_0','y_0','phi_0','cov'};

% Reorder columns to predefined order
if ~isempty(table_track_start_points) &&  ~all(strcmp(table_variables_names,table_track_start_points.Properties.VariableNames)) 
    ordered_table_track_start_points = table_track_start_points;
    for i = 2:length(table_variables_names)
        ordered_table_track_start_points = movevars(ordered_table_track_start_points,table_variables_names{i},'After',table_variables_names{i-1});
    end % for i   
else
    ordered_table_track_start_points = table_track_start_points;
end % if

end % function

