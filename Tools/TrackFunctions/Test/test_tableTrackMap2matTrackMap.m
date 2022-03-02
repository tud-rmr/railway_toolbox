clear all
close all
clc

%% 1) Convert map

track_01 = [1 1  0  0 100 160 NaN];
track_02 = [1 2  0 80 150 160 NaN];
track_03 = [3 3 80 80  80 160 NaN];
track_04 = [4 4 80  0  60 160 NaN];
original_track_map = [track_01;track_02;track_03;track_04]

table_track_map = table;
table_track_map.r_start = original_track_map(:,3);
table_track_map.r_end = original_track_map(:,4);
table_track_map.track_element = original_track_map(:,2);
table_track_map.length = original_track_map(:,5);
table_track_map.speed_limit = original_track_map(:,6);
table_track_map.ID = original_track_map(:,1);
table_track_map.cov = {zeros(3);zeros(3);zeros(3);zeros(3);};
table_track_map

[mat_track_map,track_ids,track_elements,track_start_radii,track_end_radii,track_lengths,track_speed_limits,track_cov] = tableTrackMap2matTrackMap(table_track_map)

%% 2) Create empty map

[mat_track_map,track_ids,track_elements,track_start_radii,track_end_radii,track_lengths,track_speed_limits,track_cov] = tableTrackMap2matTrackMap()

%% 3) Create empty map with ID

[mat_track_map,track_ids,track_elements,track_start_radii,track_end_radii,track_lengths,track_speed_limits,track_cov] = tableTrackMap2matTrackMap(1)
