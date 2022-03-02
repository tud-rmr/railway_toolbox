function [mat_track_map,track_ids,track_elements,track_start_radii,track_end_radii,track_lengths,track_speed_limits,track_cov] = tableTrackMap2matTrackMap(table_track_map)
% [mat_track_map,track_ids,track_elements,track_start_radii,track_end_radii,track_lengths,track_speed_limits,track_cov] = tableTrackMap2matTrackMap(table_track_map)
%
% This functions converts a track map from table-format to matrix-format, 
% e.g. for the use in Simulink. Basically it is not converted to a more
% intuitive structure-format because of performance issues, which occured 
% in the table- or structure-format.
%
% In:
%   table_track_map   trackmap as table or structure (if it is already a matrix, it will be returned directly)
%
% Out:
%   mat_track_map     trackmap as table
%   ...               table fields, directly returned as variables
%

%% Checks and initialization

% if (nargin > 0) && (size(table_track_map,2) == 1)
%     error('tableTrackMap2matTrackMap: ''track_map'' has wrong size!');
% end % if

[~,table_variable_names] = orderTableTrackMap([]);
    
%% Calculations

if (nargin==1) && (max(size(table_track_map)) == 1) && ~isstruct(table_track_map)
    mode = 'init with track-ID';
elseif nargin == 0
    mode = 'clear init';
else
    mode = 'normal mode';
end % if

% Output: track map matrix ________________________________________________
switch mode
    
    case {'clear init'} % No input agrument --> create empty track map              
        mat_track_map = NaN.*ones(1,length(table_variable_names));
        % track_cov = mat_track_map(:,strcmp(table_variable_names,'cov'));
        track_cov = NaN(3);
        
    case {'init with track-ID'} % One input argument as number --> create empty track-start-points with ID
        mat_track_map = NaN.*ones(1,length(table_variable_names));
        mat_track_map(:,strcmp(table_variable_names,'ID')) = table_track_map;
        % track_cov = mat_track_map(:,strcmp(table_variable_names,'cov'));
        track_cov = NaN(3);
    
    case {'normal mode'} % Input argument available --> convert given track map        
        if istable(table_track_map)
            % Reorder columns to predefined order
            [ordered_table_track_map,~] = orderTableTrackMap(table_track_map);

            % Convert table to matrix            
            numeric_table_entries_index = varfun(@isnumeric,ordered_table_track_map,'OutputFormat','uniform'); % find columns which can be converted to a matrix
            mat_track_map = table2array(ordered_table_track_map(:,numeric_table_entries_index)); % convert columns found above
            mat_track_map(:,~numeric_table_entries_index) = NaN;  % fill all other columns with NaN
            
            % Treatment of the trackmap's covariance
            track_cov = ordered_table_track_map.cov;
        elseif isstruct(table_track_map)
            table_track_map = struct2table(table_track_map,'AsArray',1);
            [mat_track_map,~,~,~,~,~,~,track_cov] = tableTrackMap2matTrackMap(table_track_map);
        elseif ismatrix(table_track_map)
            mat_track_map = table_track_map;
            track_cov = NaN;
        else
            error('tableTrackMap2matTrackMap: Wrong ''track_map'' type!');    
        end % if
        
    otherwise
        error('tableTrackMap2matTrackMap: Case not handled!');
        
end % switch

% Output: track map fields ________________________________________________
track_ids = mat_track_map(:,strcmp(table_variable_names,'ID'));
track_elements = mat_track_map(:,strcmp(table_variable_names,'track_element'));
track_start_radii = mat_track_map(:,strcmp(table_variable_names,'r_start'));
track_end_radii = mat_track_map(:,strcmp(table_variable_names,'r_end'));
track_lengths = mat_track_map(:,strcmp(table_variable_names,'length'));
track_speed_limits = mat_track_map(:,strcmp(table_variable_names,'speed_limit'));

end % function

