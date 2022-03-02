clear all
close all
clc

%% Init

Q = 2;
std_interval = 2;
resolution = 361;

%% Calculations

% Generate reference distribution _________________________________________
p_ref = mvnrnd(0,Q,1e5)';

% Get standard deviation curve from formula _______________________________
[polar_std_curve,cart_std_curve] = getStandardDeviationCurve(Q,std_interval,resolution);

%% Plot

% Cartesian Plot
hist(p_ref); hold on; grid on
% plot(p_ref,zeros(1,length(p_ref)),'k.'); hold on; grid on
plot([-cart_std_curve cart_std_curve],[0 0],'rx','LineWidth',3,'MarkerSize',20);
plot([-polar_std_curve polar_std_curve],[0 0],'g.','LineWidth',3,'MarkerSize',20);

