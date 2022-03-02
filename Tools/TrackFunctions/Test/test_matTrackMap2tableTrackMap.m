clear all
close all
clc

%% 1) Convert map

track_01 = [1 1  0  0 100 160 NaN];
track_02 = [1 2  0 80 150 160 NaN];
track_03 = [3 3 80 80  80 160 NaN];
track_04 = [4 4 80  0  60 160 NaN];

mat_track_map = [track_01;track_02;track_03;track_04]
track_map_cov = {zeros(3);zeros(3);zeros(3);zeros(3)};
table_track_map = matTrackMap2tableTrackMap(mat_track_map)
table_track_map = matTrackMap2tableTrackMap(mat_track_map,track_map_cov)

%% 2) Create empty map

table_track_map = matTrackMap2tableTrackMap()

%% 3) Create empty map with ID

table_track_map = matTrackMap2tableTrackMap(1)
