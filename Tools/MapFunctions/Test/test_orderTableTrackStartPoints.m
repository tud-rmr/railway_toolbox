clear all
close all
clc

%%

unordered_table_track_start_points = table;
unordered_table_track_start_points.ID = [1;2];
unordered_table_track_start_points.phi_0 = [10;0];
unordered_table_track_start_points.y_0 = [0 0;0 0];
unordered_table_track_start_points.x_0 = [0 100;0 200];
unordered_table_track_start_points.cov = {zeros(3);zeros(3)};


unordered_table_track_start_points
[ordered_table_track_position,table_var_names] = orderTableTrackStartPoints(unordered_table_track_start_points)


