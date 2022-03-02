clear all
close all
clc

rotate = @(phi) [cosd(phi) -sind(phi);sind(phi) cosd(phi)];

%% Init

Q = 1;
conf_interval = 0.95;
conf_interval = 1-1e-9;

%% Calculations

% Generate reference distribution _________________________________________
p_ref = mvnrnd(0,Q,1e5)';

% Get standard deviation curve from formula _______________________________
[rho, ~, ~] = calcErrorEllipse(Q,[],conf_interval);

% Calculate standard deviation curve from distribution ____________________
z = max(norminv([(1-conf_interval)/2 conf_interval+(1-conf_interval)/2],0,1));
rho_ref = z*std(p_ref); 

%% Test

test_number = 0;
for i = 1:length(p_ref)
    test_number = test_number + double(abs(p_ref(i))<=abs(rho));
end
test_number/length(p_ref)

%% Plot

hist(p_ref); hold on; grid on
% plot(p_ref,zeros(1,length(p_ref)),'k.'); hold on; grid on
plot([-rho rho],[0 0],'r.','LineWidth',3,'MarkerSize',20);

