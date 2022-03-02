clear all
close all
clc

%% 1) Convert map

table_track_start_points = table;
table_track_start_points.phi_0 = [10;0];
table_track_start_points.x_0 = [0;10];
table_track_start_points.y_0 = [0;0];
table_track_start_points.ID = [1;2];
table_track_start_points.cov = {zeros(3);zeros(3)};

[mat_track_start_points,track_ids,track_x0s,track_y0s,track_phi0s,track_start_points_cov] = tableTrackStartPoints2matTrackStartPoints(table_track_start_points)

%% 2) Create empty map

[mat_track_start_points,track_ids,track_x0s,track_y0s,track_phi0s,track_start_points_cov] = tableTrackStartPoints2matTrackStartPoints()

%% 3) Create empty map with ID

[mat_track_start_points,track_ids,track_x0s,track_y0s,track_phi0s,track_start_points_cov] = tableTrackStartPoints2matTrackStartPoints(1)

