clear all
close all
clc

%% Init

acc_limits = [-2 1.5];
track_rel_position = linspace(0,3000,50);
track_id = 1.*ones(1,length(track_rel_position));

track_map = [1 1 0 0 track_rel_position(end)/4 160 NaN;1 1 0 0 track_rel_position(end)/4 80 NaN;1 1 0 0 track_rel_position(end)/4 160 NaN;1 1 0 0 track_rel_position(end)/4 80 NaN];
track_map = matTrackMap2tableTrackMap(track_map);

[~,~,~,p,~,~,~,trackSpeedLimits] = calcTrackProperties(track_rel_position,track_map.ID(1),0,track_map);

max_speed = calcCurrentMaxSpeed(track_id,track_rel_position,acc_limits,160/3.6,track_map);

%% Plots

figure_name = 'Track + Speed limits';
close(findobj('Type','figure','Name',figure_name));

figure('Name',figure_name); hold on; grid on;  

clear h_plot
subplot(2,1,1); hold on; grid on; 
h_plot(1) = plot(p(1,:),p(2,:),'k.-','LineWidth',2,'MarkerSize',15,'DisplayName','Track Layout');
xlabel('x [m]')
ylabel('y [m]')
h_legend = legend(h_plot(1));
set(h_legend,'Location','best')
axis equal

clear h_plot
subplot(2,1,2); hold on; grid on;    
h_plot(1) = plot(track_rel_position,trackSpeedLimits,'r-','LineWidth',1,'MarkerSize',15,'DisplayName','track speed limit');
h_plot(2) = plot(track_rel_position,max_speed.*3.6,'b.','LineWidth',1,'MarkerSize',15,'DisplayName','signalled speed limit');
xlabel('l [m]')
ylabel('speed limit [km/h]')
h_legend = legend(h_plot([1,2]));
set(h_legend,'Location','best')

