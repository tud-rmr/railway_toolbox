function [mat_track_start_points,track_ids,track_x0s,track_y0s,track_phi0s,track_start_points_cov] = tableTrackStartPoints2matTrackStartPoints(table_track_start_points)
% [mat_track_start_points,track_ids,track_x0s,track_y0s,track_phi0s,track_start_points_cov] = tableTrackStartPoints2matTrackStartPoints(table_track_start_points)
%
% This functions converts a track-start-positions table to  matrix-format, 
% e.g. for the use in Simulink. Basically it is not converted to a more 
% intuitive structure-format because of performance issues, which occured 
% in the table- or structure-format.
%
% In:
%   table_track_start_points   track-start-positions as table or structure (if it is already a matrix, it will be returned directly)
%
% Out:
%   mat_track_start_points     track-start-positions as matrix
%   ...                        table fields, directly returned as variables
%

%% Checks and initialization

% if (nargin > 0) && (size(table_track_start_points,2) == 1)
%     error('tableTrackStartPoints2matTrackStartPoints: ''table_track_start_points'' has wrong size!');
% end % if

[~,table_variable_names] = orderTableTrackStartPoints([]);
    
%% Calculations

if (nargin==1) && (max(size(table_track_start_points)) == 1) && ~isstruct(table_track_start_points)
    mode = 'init with track-ID';
elseif nargin == 0
    mode = 'clear init';
else
    mode = 'normal mode';
end % if

% Output: track map matrix ________________________________________________
switch mode
    
    case {'clear init'} % No input agrument --> create empty track map              
        mat_track_start_points = NaN.*ones(1,length(table_variable_names));
        track_start_points_cov = NaN(3);
    
    case {'init with track-ID'} % One input argument as number --> create empty track-start-points with ID        
        mat_track_start_points = NaN.*ones(1,length(table_variable_names));
        mat_track_start_points(:,strcmp(table_variable_names,'ID')) = table_track_start_points;
        track_start_points_cov = NaN(3);
        
    case {'normal mode'} % Input argument available --> convert given track map        
        if istable(table_track_start_points)
            % Reorder columns to predefined order
            [ordered_table_track_start_points,~] = orderTableTrackStartPoints(table_track_start_points);

            % Convert table to matrix
            numeric_table_entries_index = varfun(@isnumeric,ordered_table_track_start_points,'OutputFormat','uniform'); % find columns which can be converted to a matrix
            mat_track_start_points = table2array(ordered_table_track_start_points(:,numeric_table_entries_index)); % convert columns found above
            mat_track_start_points(:,~numeric_table_entries_index) = NaN; % fill all other columns with NaN
            
            % Treatment of the trackmap's covariance
            track_start_points_cov = ordered_table_track_start_points.cov;
        elseif isstruct(table_track_start_points)
            table_track_start_points = struct2table(table_track_start_points,'AsArray',1);
            [mat_track_start_points,~,~,~,~,track_start_points_cov] = tableTrackStartPoints2matTrackStartPoints(table_track_start_points);
        elseif ismatrix(table_track_start_points)
            mat_track_start_points = table_track_start_points;
            track_start_points_cov = NaN;
        else
            error('tableTrackStartPoints2matTrackStartPoints: Wrong ''table_track_start_points'' type!');    
        end % if
    
    otherwise
        error('tableTrackStartPoints2matTrackStartPoints: Case not handled!');
        
end % switch

% Output: track map fields ________________________________________________
track_ids = mat_track_start_points(:,strcmp(table_variable_names,'ID'));
track_x0s = mat_track_start_points(:,strcmp(table_variable_names,'x_0'));
track_y0s = mat_track_start_points(:,strcmp(table_variable_names,'y_0'));
track_phi0s = mat_track_start_points(:,strcmp(table_variable_names,'phi_0'));

end % function

