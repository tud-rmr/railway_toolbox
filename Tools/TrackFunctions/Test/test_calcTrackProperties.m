clear all
close all
clc

%%

track_id_0 = 1;
track_rel_position_0 = 0;
track_map_phi = 0;
direction = 1;

track_01 = [1 1   0   0 100 160 NaN];
track_02 = [2 2   0  80  20  90 NaN];
track_03 = [3 3  80  80 100  80 NaN];
track_04 = [4 5  80 -80 100  90 NaN];
track_05 = [5 3 -80 -80 100 160 NaN];
mat_track_map = [track_01;track_02;track_03;track_04;track_05];
track_map = matTrackMap2tableTrackMap(mat_track_map);

d_train = 0:1:sum(track_map.length);

[track_id1,rel_position1,~,abs_postion1,t1,curv1,radi1,speed_limit1] = calcTrackProperties(d_train,track_map(1,:).ID,0,track_map,track_map_phi,direction);
[track_id2,rel_position2,~,abs_postion2,~,~,~,~] = calcTrackProperties(d_train,track_id_0,track_rel_position_0,track_map,track_map_phi,direction);

%%

% Track (absolute position) _______________________________________________
if(1)
    figure_name = 'Track (absolute)';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);    
    for i = unique(track_map.ID')
        h_plot(end+1) = plot(abs_postion1(1,track_id1==i),abs_postion1(2,track_id1==i),'.-','LineWidth',1.5,'MarkerSize',10,'DisplayName',sprintf('Track: %i',i));
    end % for i    
    h_plot(end+1) = plot(abs_postion2(1,1),abs_postion2(2,1),'s','LineWidth',1.5,'MarkerSize',10,'DisplayName','Train startpoint');
    xlabel('x [m]')
    ylabel('y [m]')
    
    h_legend = legend;
    set(h_legend,'Location','Best');
    axis equal
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

