clear all
close all
clc

%%

track_01 = [1 1  0  0 100 160 NaN];
track_02 = [1 2  0 80 150 160 NaN];
track_03 = [3 3 80 80  80 160 NaN];
track_04 = [4 4 80  0  60 160 NaN];
mat_track_map = [track_01;track_02;track_03;track_04];

unordered_table_track_map = table;
unordered_table_track_map.r_start = mat_track_map(:,3);
unordered_table_track_map.r_end = mat_track_map(:,4);
unordered_table_track_map.track_element = mat_track_map(:,2);
unordered_table_track_map.length = mat_track_map(:,5);
unordered_table_track_map.speed_limit = mat_track_map(:,6);
unordered_table_track_map.ID = mat_track_map(:,1);
unordered_table_track_map.cov = {zeros(3);zeros(3);zeros(3);zeros(3)};

unordered_table_track_map
[ordered_table_track_map,table_var_names] = orderTableTrackMap(unordered_table_track_map)


