clear all
close all
clc

%% Init

Q = [2^2 0.2;0.2 0.2^2];
% Q = [2^2 0;0 0.2940^2];
std_interval = 1;
resolution = 361;

%% Calculations

% Generate reference distribution _________________________________________
p_ref = mvnrnd([0;0],Q,1e5)';
[theta_p_ref,rho_p_ref] = cart2pol(p_ref(1,:),p_ref(2,:));

% Get standard deviation curve from formula _______________________________
[polar_std_curve,cart_std_curve] = getStandardDeviationCurve(Q,std_interval,resolution);

%% Plot

% Cartesian Plot
plot(p_ref(1,:),p_ref(2,:),'k.'); hold on; grid on
plot(cart_std_curve(1,:),cart_std_curve(2,:),'r.','LineWidth',3,'MarkerSize',10);
axis equal

% Polar Plot
figure;
polarplot(theta_p_ref,rho_p_ref,'k.'); hold on;
polarplot(polar_std_curve(1,:)/360*2*pi,polar_std_curve(2,:),'r','LineWidth',2);
