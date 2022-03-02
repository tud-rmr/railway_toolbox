close all
clear
clc

%% Create railway map
%

% Track parameters
v_max = 160;
R = 50;
l_1 = 500;

% Create single tracks
track_map_1 = generateStraigthTrack(11,v_max,l_1);
track_map_2 = matTrackMap2tableTrackMap([12 2 0 -R 100 v_max NaN]);
track_map_3 = matTrackMap2tableTrackMap([13 3 -R -R 2*pi*abs(R)*0.2 v_max NaN]);

% Create single track start points
% start_point_1 = matTrackStartPoints2tableTrackStartPoints([11 0 0 10 NaN]);
% start_point_2 = matTrackStartPoints2tableTrackStartPoints([12 NaN NaN NaN NaN]);
% start_point_3 = matTrackStartPoints2tableTrackStartPoints([13 NaN NaN NaN NaN]);

start_point_1 = matTrackStartPoints2tableTrackStartPoints([11 NaN NaN NaN NaN]);
start_point_2 = matTrackStartPoints2tableTrackStartPoints([12 492.4 86.824 10 NaN]);
start_point_3 = matTrackStartPoints2tableTrackStartPoints([13 NaN NaN NaN NaN]);
% 
% start_point_1 = matTrackStartPoints2tableTrackStartPoints([11 NaN NaN NaN NaN]);
% start_point_2 = matTrackStartPoints2tableTrackStartPoints([12 NaN NaN NaN NaN]);
% start_point_3 = matTrackStartPoints2tableTrackStartPoints([13 576.09 133.09 67.296 NaN]);

% Create railway map structure
railway_map.topology = [0 1 0; ... 
                        0 0 1; ... 
                        0 0 0];
railway_map.track_start_points = [start_point_1;start_point_2;start_point_3];
% railway_map.track_maps = {track_map_1;track_map_2;track_map_3;track_map_4;track_map_5;track_map_6};
railway_map.track_maps = [track_map_1;track_map_2;track_map_3];

%% Test calcMatTrackStartPoints

if(0)
    track_id = [];
    topology = railway_map.topology;
    track_start_points = railway_map.track_start_points;
    track_maps = railway_map.track_maps;
    track_start_points_cov = railway_map.track_start_points.cov;
    if iscell(railway_map.track_maps)        
        track_maps_cov = cellfun(@(cell) cell.cov,railway_map.track_maps(:),'UniformOutput',0);
    else
        track_maps_cov = railway_map.track_maps.cov;
    end % if
    [updated_track_start_point,updated_track_start_point_cov,updated_track_start_points,updated_track_start_points_cov] = calcMatTrackStartPoints(track_id,topology,track_start_points,track_maps,track_start_points_cov,track_maps_cov)
end % if

%% Test: calcTableTrackStartPoints

if(1)
    track_id = [];
    [updated_track_start_point,updated_railway_map] = calcTableTrackStartPoints(track_id,railway_map)
end % if

%% Plots

% Track (absolute position) _______________________________________________
if(1)
    [track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit,updated_railway_map] = calcMapProperties(railway_map,10);
    
    figure_name = 'Track (absolute)';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);    
    for i = unique(track_id)
        if any(track_id==i)
            h_plot(end+1) = plot(abs_position(1,track_id==i),abs_position(2,track_id==i),'.-','LineWidth',1.5,'MarkerSize',10,'DisplayName',sprintf('Track: %i',i));
        end % if
    end % for i 
    xlabel('x [m]')
    ylabel('y [m]')
    
    h_legend = legend;
    set(h_legend,'Location','Best');
    axis equal
end % if
