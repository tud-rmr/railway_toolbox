clear all
close all
clc

%%

L = 1;
l = 0:0.1:L;
R_start = 40;
R_end = 20;

[c_n,t_n,curv_n,radius_n] = clothoidTrackElement(l,L,R_start,R_end);
curvature_external = -LineCurvature2D(c_n');


%% Track (absolute position)
if(1)
    figure_name = 'Track (absolute)';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);    
    h_plot(end+1) = plot(c_n(1,:),c_n(2,:),'.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('x [m]')
    ylabel('y [m]')
    
    axis equal
end % if

%% Track Geometry
if(1)
    figure_name = 'Track Properties';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); 
    
    clear h_plot
    h_plot = gobjects(0);
    subplot(3,1,1); hold on; grid on;
    h_plot(end+1) = plot(l,atan2d(t_n(2,:),t_n(1,:)),'b.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('direction [°]')
    
    clear h_plot
    h_plot = gobjects(0); 
    subplot(3,1,2); hold on; grid on;
    h_plot(end+1) = plot(l,curvature_external,'ko','LineWidth',1.5,'MarkerSize',10);
    h_plot(end+1) = plot(l,curv_n,'b.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('curvature [1/m]')
    
    clear h_plot
    h_plot = gobjects(0); 
    subplot(3,1,3); hold on; grid on;
    h_plot(end+1) = plot(l,radius_n,'b.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('radius [m]')    
end % if