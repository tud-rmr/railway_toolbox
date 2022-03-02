clear all
close all
clc

%%

t = 0:0.001:30;

a = -2;
v_0 = 160/3.6;

v = v_0 + a.*t;
s = 1/2.*a.*t.^2;

%%

figure_name = 'Braking Curve';
close(findobj('Type','figure','Name',figure_name));
figure('Name',figure_name,'units','normalized','outerposition',[0 0 1 1]); hold on; grid on;

clear h_plot
h_plot = gobjects(0);
h_plot(end+1) = plot(-1*s,v.*3.6,'k-','LineWidth',1.5,'MarkerSize',5,'DisplayName','');
xlabel('s [m]')
ylabel('v [km/h]')

% h_legend = legend([h_plot(:)]);
% set(h_legend,'Location','Best');
% axis equal