function table_track_map = matTrackMap2tableTrackMap(mat_track_map,track_map_cov)
% table_track_map = matTrackMap2tableTrackMap(mat_track_map)
%
% In:
%   mat_track_map       trackmap as matrix (if it is already a table, it will be returned directly)
%   track_map_cov       trackmap's covariance matrices as cell vector (if not provided the covariance column is filled with NaN)
%
% Out:
%   table_track_map     trackmap as table
%

%% Checks and initialization

% if (nargin > 0) && (size(mat_track_map,2) == 1)
%     error('matTrackMap2tableTrackMap: ''track_map'' has wrong size!');
% end % if

if (nargin == 2) && (size(mat_track_map,1) ~= size(track_map_cov,1))
    error('matTrackMap2tableTrackMap: Dimension mismatch between ''track_map''and ''track_map_cov''!');
end % if

if (nargin == 1) && (max(size(mat_track_map)) ~= 1)
    track_map_cov = repmat({NaN(3)},size(mat_track_map,1),1);
end % if

if (nargin == 1) && (max(size(mat_track_map)) == 1)
    mode = 'init with track-ID';
elseif nargin == 0
    mode = 'clear init';
else
    mode = 'normal mode';
end % if

%% Calculations

% Output: track map matrix ________________________________________________
switch mode
    
    case {'clear init'} % No input agrument --> create empty track map  
        [~,table_variable_names] = orderTableTrackMap([]);
        
        table_track_map = table;
        for i = 1:length(table_variable_names)
            table_track_map = addvars(table_track_map,NaN,'NewVariableNames',table_variable_names(i));
        end % for i
        table_track_map.cov = {NaN(3)};
    
    case {'init with track-ID'} % One input argument as number --> create empty trackmap with ID
        [~,table_variable_names] = orderTableTrackMap([]);
        
        table_track_map = table;
        for i = 1:length(table_variable_names)
            table_track_map = addvars(table_track_map,NaN,'NewVariableNames',table_variable_names(i));
        end % for i
        table_track_map.ID = mat_track_map;
        table_track_map.cov = {NaN(3)};
        
    case {'normal mode'} % Input argument available --> convert given track map
        if ismatrix(mat_track_map) && ~istable(mat_track_map)  
            [~,table_variable_names] = orderTableTrackMap([]);
            table_track_map = array2table(mat_track_map,'VariableNames',table_variable_names);
            table_track_map.cov = track_map_cov;
        elseif istable(mat_track_map)
            table_track_map = mat_track_map;
        else
            error('matTrackMap2tableTrackMap: Wrong ''track_map'' type!');    
        end % if
        
    otherwise
        error('matTrackMap2tableTrackMap: Case not handled!');
        
end % switch

end % function

