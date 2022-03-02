clear all
close all
clc

rotate = @(phi) [cosd(phi) -sind(phi);sind(phi) cosd(phi)];

%% Init

Q = 1;
conf_interval = 0.95;

%% Calculations

p_ref = mvnrnd(0,Q,1e5)';

[polar_err_ellipse,cartesian_err_ellipse] = getErrorEllipse(Q,conf_interval,[]);

%% Plot

hist(p_ref); hold on; grid on
% plot(p_ref,zeros(1,length(p_ref)),'k.'); hold on; grid on
plot([-cartesian_err_ellipse cartesian_err_ellipse],[0 0],'rx','LineWidth',3,'MarkerSize',20);
plot([-polar_err_ellipse polar_err_ellipse],[0 0],'g.','LineWidth',3,'MarkerSize',20);
