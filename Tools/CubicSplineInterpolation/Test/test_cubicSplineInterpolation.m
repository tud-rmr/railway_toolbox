close all
clear
clc

%% Reference curve

% Curve parameters
v_max = 60; % in km/h
R_min = 30; % in m

% Create curve
track_map = generateSShapedTrack(1,v_max,R_min,0.0);
% track_map = generateEightShapedTrack(1,v_max,R_min,0.0);
% track_map = generateRoundTrack(1,v_max,R_min);
% track_map = generateRndTrack(1,500,v_max,R_min,5);
% track_map = generateStraigthTrack(1,500,v_max);

% Create reference data
L_ref_end = sum(track_map.length);
l_ref = (0:1:L_ref_end)';
l_i_ref = [0;cumsum(diff(l_ref))];

% Create measurement data
l_meas_selector = 1 : 60/mean(diff(l_ref)) : length(l_ref);
l_meas = l_ref(l_meas_selector);
l_i_meas = l_i_ref(l_meas_selector);

% Create curves
[~,~,~,s_ref,t_ref,~,~,~] = calcTrackProperties(l_ref(1:l_meas_selector(end)),track_map.ID(1),0,track_map);

s_meas = s_ref(:,l_meas_selector);
t_meas = t_ref(:,l_meas_selector);

q_x = s_meas(1,:)';
q_y = s_meas(2,:)';
q = [q_x; q_y];

%% Test

figure(1);clf;
plot(s_ref(1,:),s_ref(2,:),'r'); hold on;
plot(q_x,q_y,'mo','LineWidth',2,'MarkerSize',10);
axis equal

[s_best_spline,t_best_spline] = cubicSpline(q,l_i_meas,linspace(l_i_meas(1),l_i_meas(end),length(l_ref)));
plot(s_best_spline(1,:),s_best_spline(2,:),'k-.','LineWidth',2);

% figure(2);
% phi = atan2d(t_best_spline(2,:),t_best_spline(1,:));
% plot(l_ref,phi);

for i = 1:1
    % Spline
    l_i_recursive = calcRecursiveArcLength(q,i);
    l_recursive = linspace(l_i_recursive(1),l_i_recursive(end),length(l_ref));
    [s_recursive,t_recursive] = cubicSpline(q,l_i_recursive,l_recursive);
    
    % Evaluation
    P = s_ref';
    Q = s_recursive';
    [d_f,cSq] = DiscreteFrechetDist(P,Q);
    %disp([cSq sqrt(sum((P(cSq(:,1),:) - Q(cSq(:,2),:)).^2,2))])
    [L_max,max_index] = max(abs(l_i_meas-l_i_recursive));
    [d_f;L_max]
        
    % Plot
    plot(s_recursive(1,:),s_recursive(2,:),'--','LineWidth',1); 
    %s_l_i = cubicSpline(q,l_i_recursive,l_i_recursive);
    %plot(s_l_i(1,:),s_l_i(2,:),'gx');
    
end % for i
