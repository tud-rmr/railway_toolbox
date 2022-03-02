close all
clear
clc

%% Create railway map
%
% Map layout:
%
%          __(2)__
%         /       \
% __(1)__/___(3)___\__(4)__
% [offset]___________(5)___________|___________(6)___________

% Track parameters
v_max = 160;
transition_length = 16;
transition_heigth = 4;
l_1 = 500;
l_2 = l_1;
l_3 = l_1;
l_4 = l_1;
l_5 = l_1+l_1+l_1+2*transition_length;
l_6 = l_5;

% Create single tracks
track_map_1 = generateStraigthTrack(11,v_max,l_1);
track_map_2_01 = generateTransitionTrack(12,v_max,transition_heigth,transition_length);
track_map_2_02 = generateStraigthTrack(12,v_max,l_2);
track_map_2_03 = track_map_2_01;
track_map_2_03.r_start = -1*track_map_2_03.r_start;
track_map_2_03.r_end = -1*track_map_2_03.r_end;
track_map_2 = [track_map_2_01;track_map_2_02;track_map_2_03];
track_map_3 = generateStraigthTrack(13,v_max,l_3);
track_map_4 = generateStraigthTrack(14,v_max,l_4);
track_map_5 = generateStraigthTrack(15,v_max,l_5);
track_map_6 = generateStraigthTrack(16,v_max,l_6);

% Create single track start points
start_point_1 = matTrackStartPoints2tableTrackStartPoints([11 NaN NaN NaN NaN]);
start_point_2 = matTrackStartPoints2tableTrackStartPoints([12 NaN NaN NaN NaN]);
start_point_3 = matTrackStartPoints2tableTrackStartPoints([13 NaN NaN NaN NaN]);
start_point_4 = matTrackStartPoints2tableTrackStartPoints([14 0 0 0 NaN]);
start_point_5 = matTrackStartPoints2tableTrackStartPoints([15 1000 0 0 NaN]);
start_point_6 = matTrackStartPoints2tableTrackStartPoints([16 NaN NaN NaN NaN]);

% Create railway map structure
railway_map.topology = [0 1 1 0 0 0; ... 
                        0 0 0 1 0 0; ...
                        0 0 0 1 0 0; ...
                        0 0 0 0 0 0; ... 
                        0 0 0 0 0 1; ... 
                        0 0 0 0 0 0];
railway_map.track_start_points = [start_point_1;start_point_2;start_point_3;start_point_4;start_point_5;start_point_6];
% railway_map.track_maps = {track_map_1;track_map_2;track_map_3;track_map_4;track_map_5;track_map_6};
railway_map.track_maps = [track_map_1;track_map_2;track_map_3;track_map_4;track_map_5;track_map_6];

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
