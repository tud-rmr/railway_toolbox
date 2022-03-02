clear all
close all
clc

rotate = @(phi) [cosd(phi) -sind(phi);sind(phi) cosd(phi)];

%% Init

Q = [2^2 0.2;0.2 0.2^2];
% Q = [2^2 0;0 0.2940^2];
theta_in_deg = 0:1:360;
std_interval = 1;

%% Calculations

% Generate reference distribution _________________________________________
p_ref = mvnrnd([0;0],Q,1e5)';
[theta_p_ref,rho_p_ref] = cart2pol(p_ref(1,:),p_ref(2,:));

% Get standard deviation curve from formula _______________________________
[rho_p_1, p_1, theta_0] = calcStandardDeviationCurve(Q,theta_in_deg,std_interval);
[test1,test2] = getStandardDeviationCurve(Q,std_interval,361);

% Calculate standard deviation curve from distribution ____________________
% z = max(norminv([(1-conf_interval)/2 conf_interval+(1-conf_interval)/2],0,1));
z = std_interval;

alpha_0 = theta_0;
alpha = (0:12:360);
theta_p_2 = zeros(length(alpha),1);
rho_p_2 = theta_p_2;
for alpha_index = 1:length(alpha)
    alpha_i = alpha(alpha_index);
    p_alpha_i = rotate(alpha_i-alpha_0)*p_ref;    
    
    % std_alpha = sqrt(chi2inv(conf_interval,2))*std(p_alpha(1,:));    
    theta_p_2(alpha_index) = alpha_i+alpha_0;
    rho_p_2(alpha_index) = z*std(p_alpha_i(1,:)); 
end % for alpha_index

%% Test

% temp = chi2inv(conf_interval,length(S));
% temp = norminv([(1-conf_interval)/2 conf_interval+(1-conf_interval)/2],0,1);

test_number = 0;
for i = 1:length(p_ref)
    std_test = calcStandardDeviationCurve(Q,theta_p_ref(i)/(2*pi)*360,std_interval);
    test_number = test_number + double(abs(rho_p_ref(i)*cos(theta_p_ref(i)))<=abs(std_test));
end
test_number/length(p_ref)

%% Plot

% Cartesian Plot
plot(p_ref(1,:),p_ref(2,:),'k.'); hold on; grid on

plot(p_1(1,:),p_1(2,:),'r.','LineWidth',3,'MarkerSize',10);

[p_2_x,p_2_y] = pol2cart(theta_p_2./360*2*pi,rho_p_2);
plot(p_2_x,p_2_y,'gx','LineWidth',3,'MarkerSize',10);
axis([-8.5 8.5 -8.5 8.5])

% Polar Plot
figure;
polarplot(theta_p_ref,rho_p_ref,'k.'); hold on;
polarplot(theta_in_deg./360*2*pi,rho_p_1,'r','LineWidth',2);
polarplot(theta_p_2./360*2*pi,rho_p_2,'gx');
