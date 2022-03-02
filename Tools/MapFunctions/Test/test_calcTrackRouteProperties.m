close all
clear
clc

%% Train route

d_train = 0:1:300;
track_route = [11 12 14];
track_route_id_0 = 11;
track_route_rel_position_0 = 0;
direction = 1;

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
track_map_2_03 = track_map_2_01;
track_map_2_03.r_start = -1*track_map_2_03.r_start;
track_map_2_03.r_end = -1*track_map_2_03.r_end;
track_map_2 = [track_map_2_01;track_map_2_02;track_map_2_03];
track_map_3 = generateStraigthTrack(13,v_max,l_3);
track_map_4 = generateStraigthTrack(14,v_max,l_4);
track_map_5 = generateStraigthTrack(15,v_max,l_5);
track_map_6 = generateStraigthTrack(16,v_max,l_6);

% Create single track start points
start_point_1 = matTrackStartPoints2tableTrackStartPoints([11 0 0 0 NaN]);
start_point_2 = matTrackStartPoints2tableTrackStartPoints([12 NaN NaN NaN NaN]);
start_point_3 = matTrackStartPoints2tableTrackStartPoints([13 NaN NaN NaN NaN]);
start_point_4 = matTrackStartPoints2tableTrackStartPoints([14 NaN NaN NaN NaN]);
start_point_5 = matTrackStartPoints2tableTrackStartPoints([15 0 -10 0 NaN]);
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

[track_id1,rel_position1,~,abs_postion1,t1,curv1,radi1,speed_limit1,track_map,railway_map] = calcTrackRouteProperties(d_train,track_route,track_route(1),0,railway_map,direction);
[track_id2,rel_position2,~,abs_postion2,~,~,~,~,~,~] = calcTrackRouteProperties(d_train,track_route,track_route_id_0,track_route_rel_position_0,railway_map,direction);

%%

%%

% Track (absolute position) _______________________________________________
if(1)
    figure_name = 'Track (absolute)';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);    
    for i = unique(track_map.ID')
        if any(track_id1==i)
            h_plot(end+1) = plot(abs_postion1(1,track_id1==i),abs_postion1(2,track_id1==i),'.-','LineWidth',1.5,'MarkerSize',10,'DisplayName',sprintf('Track: %i',i));
        end % if
    end % for i    
    h_plot(end+1) = plot(abs_postion2(1,1),abs_postion2(2,1),'s','LineWidth',1.5,'MarkerSize',10,'DisplayName','Train startpoint');
    xlabel('x [m]')
    ylabel('y [m]')
    
    h_legend = legend;
    set(h_legend,'Location','Best');
    %axis equal
end % if

% Track (relative position) _______________________________________________
if(1)
    figure_name = 'Track (relative)';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0); 
    for i = unique(track_map.ID')
        if any(track_id2==i)
            h_plot(end+1) = plot(d_train(track_id2==i),rel_position2(track_id2==i),'.-','LineWidth',1.5,'MarkerSize',10,'DisplayName',sprintf('Track: %i',i));
        else
            continue;
        end
    end % for i    
    xlabel('d_{train} [m]')
    ylabel('relative position to trackmap [m]')
    
    ylim([min(rel_position2) max(rel_position2)])
    h_legend = legend;
    set(h_legend,'Location','Best');
end % if

% Track Geometry __________________________________________________________
if(1)
    figure_name = 'Track Properties';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);    
    ax1 = subplot(4,1,1); hold on; grid on; 
    h_plot(end+1) = plot(d_train,atan2d(t1(2,:),t1(1,:)),'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('track orientation [deg]')

    clear h_plot
    h_plot = gobjects(0);    
    ax2 = subplot(4,1,2); hold on; grid on; 
    h_plot(end+1) = plot(d_train,curv1,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('curvature [1/m]')

    clear h_plot
    h_plot = gobjects(0);    
    ax3 = subplot(4,1,3); hold on; grid on; 
    h_plot(end+1) = plot(d_train,radi1,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('radius [m]')

    clear h_plot
    h_plot = gobjects(0);    
    ax4 = subplot(4,1,4); hold on; grid on; 
    h_plot(end+1) = plot(d_train,speed_limit1,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('speed limit [km/h]')

    % h_legend = legend(h_plot(:));
    % set(h_legend,'Location','southeast')
    linkaxes([ax1,ax2,ax3,ax4],'x');
end % if
