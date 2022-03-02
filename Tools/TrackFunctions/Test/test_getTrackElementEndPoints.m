clear all
close all
clc

%%

track_element = [1 4];

track_01 = [1 1  0  0 100 160 NaN];
track_02 = [1 2  0 80 150 160 NaN];
track_03 = [3 3 80 80  80 160 NaN];
track_04 = [4 4 80  0  60 160 NaN];
mat_track_map = [track_01;track_02;track_03;track_04];
tab_track_map = matTrackMap2tableTrackMap(mat_track_map);

[track_element_starting_point,track_element_ending_point] = getTrackElementEndPoints(track_element,tab_track_map)
