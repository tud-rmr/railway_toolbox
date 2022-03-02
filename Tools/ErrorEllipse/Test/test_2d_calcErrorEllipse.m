clear all
close all
clc

rotate = @(phi) [cosd(phi) -sind(phi);sind(phi) cosd(phi)];

%% Init

Q = [2^2 0.35;0.35 0.2^2];
% Q = [2^2 0;0 0.2940^2];
% Q = [0.5625, 0.5625;
%      0.5625,0.5625];
% Q = [1, 0;
%      0,0];
theta_in_deg = 0:1:360;
conf_interval = 0.95;
% conf_interval = 1-1e-9;

%% Calculations

% Generate reference distribution _________________________________________
p_ref = mvnrnd([0;0],Q,1e5)';
[theta_p_ref,rho_p_ref] = cart2pol(p_ref(1,:),p_ref(2,:));

% Get error ellipse from formula __________________________________________
[rho_p_1, p_1, theta_0] = calcErrorEllipse(Q,theta_in_deg,conf_interval);

%% Test

test_number = 0;
for i = 1:length(p_ref)
    e_test = calcErrorEllipse(Q,theta_p_ref(i)/(2*pi)*360,conf_interval);
    test_number = test_number + double(abs(rho_p_ref(i))<=abs(e_test));
end
test_number/length(p_ref)

% calcErrorEllipse(Q,0,0.95)

%% Plot

% Cartesian Plot __________________________________________________________
plot(p_ref(1,:),p_ref(2,:),'k.'); hold on; grid on
plot(p_1(1,:),p_1(2,:),'r','LineWidth',3,'MarkerSize',10);
axis equal

% Polarplot
figure;
polarplot(theta_p_ref,rho_p_ref,'k.'); hold on;
polarplot(theta_in_deg./360*2*pi,rho_p_1,'r','LineWidth',2);
