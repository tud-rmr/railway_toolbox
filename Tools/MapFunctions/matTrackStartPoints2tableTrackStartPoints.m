function table_track_start_points = matTrackStartPoints2tableTrackStartPoints(mat_track_start_points,track_start_points_cov)
% table_track_start_points = matTrackStartPoints2tableTrackStartPoints(mat_track_start_points,track_start_points_cov)
%
% In:
%   mat_track_start_points       track-start-points position as matrix (if it is already a table, it will be returned directly)
%   track_start_points_cov       track-start-points covariance matrices as cell vector (if not provided the covariance column is filled with NaN)
%
% Out:
%   table_track_start_points     track-start-points as table
%

%% Checks and initialization

% if (nargin > 0) && (size(mat_track_start_points,2) == 1)
%     error('matTrackStartPoints2tableTrackStartPoints: ''mat_track_start_points'' has wrong size!');
% end % if

if (nargin == 2) && (size(mat_track_start_points,1) ~= size(track_start_points_cov,1))
    error('matTrackStartPoints2tableTrackStartPoints: Dimension mismatch between ''mat_track_start_points''and ''track_start_points_cov''!');
end % if

if (nargin == 1) && (length(mat_track_start_points) ~= 1)
    track_start_points_cov = repmat({NaN(3)},size(mat_track_start_points,1),1);
end % if

if (nargin == 1) && (length(mat_track_start_points) == 1)
    mode = 'init with track-ID';
elseif nargin == 0
    mode = 'clear init';
else
    mode = 'normal mode';
end % if

%% Calculations

% Output: track map matrix ________________________________________________
switch mode
    
    case {'clear init'} % No input agrument --> create empty track-start-points
        [~,table_variable_names] = orderTableTrackStartPoints([]);
        
        table_track_start_points = table;
        for i = 1:length(table_variable_names)
            table_track_start_points = addvars(table_track_start_points,NaN,'NewVariableNames',table_variable_names(i));
        end % for i
        table_track_start_points.cov = {NaN(3)};
        
    case {'init with track-ID'} % One input argument as number --> create empty track-start-points with ID
        [~,table_variable_names] = orderTableTrackStartPoints([]);
        
        table_track_start_points = table;
        for i = 1:length(table_variable_names)
            table_track_start_points = addvars(table_track_start_points,NaN,'NewVariableNames',table_variable_names(i));
        end % for i
        table_track_start_points.ID = mat_track_start_points;
        table_track_start_points.cov = {NaN(3)};       
               
    case {'normal mode'} % Input argument available --> convert given track-start-points
        if ismatrix(mat_track_start_points) && ~istable(mat_track_start_points)
            [~,table_variable_names] = orderTableTrackStartPoints([]);
            table_track_start_points = array2table(mat_track_start_points,'VariableNames',table_variable_names);
            table_track_start_points.cov = track_start_points_cov;
        elseif istable(mat_track_start_points)
            table_track_start_points = mat_track_start_points;
        else
            error('matTrackStartPoints2tableTrackStartPoints: Wrong ''mat_track_start_points'' type!');    
        end % if
        
    otherwise
        error('matTrackStartPoints2tableTrackStartPoints: Case not handled!');           
        
end % switch

end % function

