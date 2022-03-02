clear all
close all
clc

%% Init

Q = [2^2 0.35;0.35 0.2^2];
conf_interval = 1-1e-9;
resolution = 360;

%% Calculations

p_ref = mvnrnd([0;0],Q,1e5)';
[theta_p_ref,rho_p_ref] = cart2pol(p_ref(1,:),p_ref(2,:));

[polar_err_ellipse,cartesian_err_ellipse] = getErrorEllipse(Q,conf_interval,resolution);

%% Plot

% Cartesian Plot 
plot(p_ref(1,:),p_ref(2,:),'k.'); hold on; grid on
plot(cartesian_err_ellipse(1,:),cartesian_err_ellipse(2,:),'r','LineWidth',3,'MarkerSize',10);
axis equal

% Polarplot
figure;
polarplot(theta_p_ref,rho_p_ref,'k.'); hold on;
polarplot(polar_err_ellipse(1,:)./360*2*pi,polar_err_ellipse(2,:),'r','LineWidth',2);
