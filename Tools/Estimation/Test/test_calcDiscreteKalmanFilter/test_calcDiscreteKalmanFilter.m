clear all
close all
clc

%% Settings

% Example from:
% "Y. Bar-Shalom et al., Estimation with applications to tracking and
% navigation: theory algorithms and software, 2001" Section 5.3, P. 218ff.

T = 0.5; % sample time in seconds

sigma_v = 1; % standard deviation of system noise
sigma_w = 10; % standard deviation of measurement noise
Gamma = [1/2*T^2; T];
Q = Gamma*sigma_v^2*Gamma';
R = sigma_w^2;

x_0_ref = [0;10];
x_0 = [0;0];
P_0 = Q;

%% Init

t = 0:T:50;

% generate reference data _________________________________________________
x_ref = [x_0_ref,zeros([size(x_0,1),length(t)-1])];
for i = 2:length(t)
    x_ref(:,i) = [1 T;0 1]*x_ref(:,i-1);
end % for i

% generate measurement data _______________________________________________
z = [0,x_ref(1,2:end) + sigma_w*randn(1,length(t)-1)];

%% Calculations
x_hat = [x_0,zeros([size(x_0,1),length(t)-1])];
P = cat(3,P_0,zeros([size(x_0,1) size(x_0,1) length(t)-1]));
nu = [0,zeros(1,length(t)-1)];
S = zeros([size(z,1) size(z,1) length(t)]);
for i = 2:length(t)
    [x_hat(:,i),P(:,:,i),nu(i),S(:,:,i)] = calcDiscreteKalmanFilter(0,z(i),Q,R,x_hat(:,i-1),P(:,:,i-1),'stateTransitionFcn','measurementFcn',T);
end % for i

%% Plots

figure_name = 'Test Kalman Filtering Fcn';
close(findobj('Type','figure','Name',figure_name));
figure('Name',figure_name); hold on; grid on;

clear h_plot
h_plot = gobjects(0);
ax1 = subplot(2,1,1); hold on; grid on; 
h_plot(end+1) = plot(t,z,'kx','LineWidth',1.5,'MarkerSize',5,'DisplayName','sensor');
h_plot(end+1) = plot(t,x_ref(1,:),'r-','LineWidth',1.5,'MarkerSize',10,'DisplayName','reference');    
h_plot(end+1) = plot(t,x_hat(1,:),'m.-','LineWidth',1.5,'MarkerSize',10,'DisplayName','KF');
xlabel('time [s]')
ylabel('x_1 [m]')
h_legend = legend(h_plot(:));
set(h_legend,'Location','southeast')

clear h_plot
h_plot = gobjects(0);    
ax2 = subplot(2,1,2); hold on; grid on; 
h_plot(end+1) = plot(t,x_ref(2,:),'r-','LineWidth',1.5,'MarkerSize',10,'DisplayName','reference');    
h_plot(end+1) = plot(t,x_hat(2,:),'m.-','LineWidth',1.5,'MarkerSize',10,'DisplayName','KF');
xlabel('time [s]')
ylabel('x_2 [m/s]')
h_legend = legend(h_plot(:));
set(h_legend,'Location','southeast')   

linkaxes([ax1,ax2],'x');