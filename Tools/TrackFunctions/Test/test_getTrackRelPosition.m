clear all
close all
clc

%%

track_map_abs_position = [249 1]';

track_01 = [1 1  0  0 100 160 NaN];
track_02 = [1 2  0 80 150 160 NaN];
track_03 = [3 3 80 80  80 160 NaN];
track_04 = [4 4 80  0  60 160 NaN];
track_map = matTrackMap2tableTrackMap([track_01;track_02;track_03;track_04]);

[track_element_starting_point,~] = getTrackElementEndPoints(1:size(track_map,1),track_map)
[track_id,track_rel_position,track_element_rel_position] = getTrackRelPosition(track_map_abs_position,track_map)
