clear all
close all
clc

%%

track_map_01 = generateStraigthTrack(1,160,100);
track_map_02 = generateTurnTrack(2,160,50,180);
track_map_03 = generateStraigthTrack(3,160,100);

map.topology = [0 1 0;0 0 1;0 0 0];
map.track_start_points = [matTrackStartPoints2tableTrackStartPoints([1 0 0 0 NaN]);matTrackStartPoints2tableTrackStartPoints(2);matTrackStartPoints2tableTrackStartPoints(3)];
map.track_maps = [track_map_01;track_map_02;track_map_03];


%%

[mat_track_start_points,track_ids,track_x0s,track_y0s,track_phi0s,~] = tableTrackStartPoints2matTrackStartPoints(calcTableTrackStartPoints([],map));

R = 50;
t_start1 = [cosd(track_phi0s(1));sind(track_phi0s(1))];
t_end1 = [cosd(10);sind(10)];

t_start2 = [cosd(170);sind(170)];
t_end2 = [cosd(track_phi0s(3));sind(track_phi0s(3))];

L1 = calcClothoidLength(R,t_start1,t_end1);
L2 = calcClothoidLength(R,t_start2,t_end2);

map2 = map;
map2.track_maps(2,:).r_end = R;
map2.track_maps(2,:).length = L1;
map2.track_maps(4,:).r_start = R;
map2.track_maps(4,:).length = L2;

[track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit,updated_railway_map] = calcMapProperties(map2,1);
% [track_id,track_rel_position,abs_position,orientation,curvature,radius,speed_limit,updated_railway_map] = calcMapProperties(map,1);

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


