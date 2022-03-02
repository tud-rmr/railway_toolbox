clear all
close all
clc

%% 1) Convert map

mat_track_start_points = [1 0 0 10 NaN;2 10 0 0 NaN];
mat_track_start_points_cov = {zeros(3);zeros(3)};
table_track_map = matTrackStartPoints2tableTrackStartPoints(mat_track_start_points)
table_track_map = matTrackStartPoints2tableTrackStartPoints(mat_track_start_points,mat_track_start_points_cov)

%% 2) Create empty map

table_track_map = matTrackStartPoints2tableTrackStartPoints()

%% 3) Create empty map with ID

table_track_map = matTrackStartPoints2tableTrackStartPoints(2)

