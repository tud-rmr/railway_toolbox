clear all
close all
clc

%% Init

acc_limits = [-2 1.5];
v_current = 160;
delta_v = 30;

braking_distance = estimateBrakingDistance(v_current/3.6,delta_v./3.6,acc_limits)

%% Plots

figure_name = 'Braking Distance';
close(findobj('Type','figure','Name',figure_name));
figure('Name',figure_name); hold on; grid on;  

clear h_plot
h_plot = gobjects(0);    
h_plot(1) = plot(delta_v,braking_distance,'k.-','LineWidth',2,'MarkerSize',15,'DisplayName','');
xlabel('\Delta v [km/h]')
ylabel('braking distance [m]')
% h_legend = legend(h_plot(1));
% set(h_legend,'Location','best')
% axis equal

