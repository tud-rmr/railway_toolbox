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
l_1 = 100;
l_2 = l_1;
l_3 = l_1+2*transition_length;
l_4 = l_1;
l_5 = (l_1+l_3+l_4)/2;
l_6 = l_5;

% Create single tracks
track_map_1 = generateStraigthTrack(11,v_max,l_1);
track_map_2_01 = generateTransitionTrack(12,v_max,transition_heigth,transition_length);
track_map_2_02 = generateStraigthTrack(12,v_max,l_2);
% track_map_2_03 = generateTransitionTrack(12,v_max,-transition_heigth,transition_length);
track_map_2_03 = track_map_2_01;
track_map_2_03.r_start = -1*track_map_2_03.r_start;
track_map_2_03.r_end = -1*track_map_2_03.r_end;
track_map_2 = [track_map_2_01;track_map_2_02;track_map_2_03];
track_map_3 = generateStraigthTrack(13,v_max,l_3);
track_map_4 = generateStraigthTrack(14,v_max,l_4);
track_map_5 = generateStraigthTrack(15,v_max,l_5);
track_map_6 = generateStraigthTrack(16,v_max,l_6);

% Create single track start points
start_point_1 = matTrackStartPoints2tableTrackStartPoints([11 0 0 1 NaN]);
start_point_2 = matTrackStartPoints2tableTrackStartPoints([12 NaN NaN NaN NaN]);
start_point_3 = matTrackStartPoints2tableTrackStartPoints([13 NaN NaN NaN NaN]);
start_point_4 = matTrackStartPoints2tableTrackStartPoints([14 NaN NaN NaN NaN]);
start_point_5 = matTrackStartPoints2tableTrackStartPoints([15 0 -4 1 NaN]);
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

%% Tests

[track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit,updated_railway_map] = calcMapProperties(railway_map,1);

%%

%%

% Track (absolute position) _______________________________________________
if(1)
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

