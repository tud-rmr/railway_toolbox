clear all
close all
clc

%% Randomly generate a map

L = 10; % in km
v_max = 160; % in km/h
R_min = 300; % in m

numTrackElements = 10; % real number (number of track parts)

track_map = generateRndTrack(1,v_max,L*1000,R_min,numTrackElements);

%% Plots

d_train = linspace(0,1*sum(track_map.length),100);
[track_id,rel_position,~,abs_postion,t,curv,radii,speed_limit] = calcTrackProperties(d_train,track_map(1,:).ID,0,track_map,0,1);

% Track (absolute position) _______________________________________________
if(1)
    figure_name = 'Track (absolute)';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);    
    for i = unique(track_map.ID')
        h_plot(end+1) = plot(abs_postion(1,track_id==i),abs_postion(2,track_id==i),'.-','LineWidth',1.5,'MarkerSize',10,'DisplayName',sprintf('Track: %i',i));
    end % for i    
    h_plot(end+1) = plot(abs_postion(1,1),abs_postion(2,1),'s','LineWidth',1.5,'MarkerSize',10,'DisplayName','Train startpoint');
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
        if any(track_id==i)
            h_plot(end+1) = plot(d_train(track_id==i),rel_position(track_id==i),'.-','LineWidth',1.5,'MarkerSize',10,'DisplayName',sprintf('Track: %i',i));
        else
            continue;
        end
    end % for i    
    xlabel('d_{train} [m]')
    ylabel('relative position to trackmap [m]')
    
    ylim([0 sum(track_map.length)])
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
    h_plot(end+1) = plot(d_train,atan2d(t(2,:),t(1,:)),'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('track orientation [deg]')

    clear h_plot
    h_plot = gobjects(0);    
    ax2 = subplot(4,1,2); hold on; grid on; 
    h_plot(end+1) = plot(d_train,curv,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('curvature [1/m]')

    clear h_plot
    h_plot = gobjects(0);    
    ax3 = subplot(4,1,3); hold on; grid on; 
    h_plot(end+1) = plot(d_train,radii,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('radius [m]')

    clear h_plot
    h_plot = gobjects(0);    
    ax4 = subplot(4,1,4); hold on; grid on; 
    h_plot(end+1) = plot(d_train,speed_limit,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('speed limit [km/h]')

    % h_legend = legend(h_plot(:));
    % set(h_legend,'Location','southeast')
    linkaxes([ax1,ax2,ax3,ax4],'x');
end % if