function [ordered_table_track_map,table_variables_names] = orderTableTrackMap(table_track_map)
% [ordered_table_track_map,table_variables_names] = orderTableTrackMap(table_track_map)
%
% In:
%   table_track_map     trackmap in table format
%
% Out:
%   ordered_table_track_map     ordered trackmap
%   table_variables_names       names to which the trackmap has been ordered
%

% Check input argument
if nargin == 0
    table_track_map = [];
end % if

% Define variables names and order
table_variables_names = {'ID','track_element','r_start','r_end','length','speed_limit','cov'};

% Reorder columns to predefined order
if ~isempty(table_track_map) &&  ~all(strcmp(table_variables_names,table_track_map.Properties.VariableNames)) 
    ordered_table_track_map = table_track_map;
    for i = 2:length(table_variables_names)
        ordered_table_track_map = movevars(ordered_table_track_map,table_variables_names{i},'After',table_variables_names{i-1});
    end % for i   
else
    ordered_table_track_map = table_track_map;
end % if

end % function

