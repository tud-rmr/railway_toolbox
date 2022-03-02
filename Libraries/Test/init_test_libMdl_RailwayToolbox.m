close all
clear all
clc

%% Settings

% Simulation parameters ___________________________________________________

t_end = 120;         % 0 --> automatic (approximately according to track length)
                     % t --> time in sec
fix_rng = 1;         % fix random generator (1) or not (0)
T_system = 0.5;      % sample time of reference system and Kalman filter
T_meas = 0.01;       % sample time of measurement noise generation

track_shape = 'track4';    % see switch case selection below
phi_track = 10;            % map rotation angle in degree

% Data-Generator __________________________________________________________

% Vehicle
max_train_acc = [-2 1.5]; % [max_decceleration max_acceleration] in m/s^2
v_train_desired_kmh  = 200; % desired vehicle speed in km/h
track_id_0           = 4;
track_rel_position_0 = 0; % in m
v_train_0            = v_train_desired_kmh/3.6; % in m/s
a_train_0            = 0; % in m/s^2

% Measurement noises
sigma_w_gps_ref  = 10;    % standard deviation of GPS (in m)
sigma_w_acc_ref  = 1e-3*9.81;  % standard deviation of acceleration sensor (in m/s^2)
sigma_w_gyro_ref = 0.05*(2*pi/360);  % standard deviation of turn rate sensor (in rad/s)

% Kalman Filter ___________________________________________________________

% system noise
sigma_v_acc  = 1.5*T_system; % standard deviation of system motion
sigma_v_gyro = 0.01*T_system;   % standard deviation of system turn rate

% Measurement noise               
sigma_w_gps_kf  = 10;    % standard deviation of GPS (in m)
sigma_w_acc_kf  = 1e-3*9.81;  % standard deviation of acceleration sensor (in m/s^2)
sigma_w_gyro_kf = 0.05*(2*pi/360);  % standard deviation of turn rate sensor (in rad/s)

%% Init

% Init track ______________________________________________________________

% Track element types:
% -----|--------------------
%   #  | Type
% -----|--------------------
%   1  | straight
%   2  | normal clothoid
%   3  | circular arc
%   4  | reverse clothoid
%   5  | turn clothoid

switch track_shape
    case {'track1'}  % straight track      
        track_ID = 1;
        track_part_length = 3000; % in m
        track_v_max = 160; % in km/h

        table_track_map = generateStraigthTrack(track_ID,track_v_max,track_part_length);       
    case {'track2'} % round track        
        track_ID = 2;
        track_radius = 500;
        track_v_max = 160;

        table_track_map = generateRoundTrack(track_ID,track_v_max,track_radius);
    case {'track3'} % turning track        
        track_ID = 3;
        track_radius = 500; % in m
        track_v_max = 160;  % in km/h
        track_turn_in_deg = 180; % in degree

        table_track_map = generateTurnTrack(track_ID,track_v_max,track_radius,track_turn_in_deg);
    case {'track4'} % combination of various track types
        track_ID = 4;
        track_radius_01 = 900; % in m
        track_radius_02 = 300; % in m
        track_part_length = 1000; % in m
        track_v_max = 160; % in km/h
        track_turn_01_in_deg = -45; % in degree
        track_turn_02_in_deg = 60; % in degree

        track_map_01 = generateStraigthTrack(track_ID,track_v_max,track_part_length);
        track_map_02 = generateTurnTrack(track_ID,track_v_max,track_radius_01,track_turn_01_in_deg);    
        track_map_03 = generateStraigthTrack(track_ID,track_v_max,track_part_length);
        track_map_04 = generateTurnTrack(track_ID,track_v_max,track_radius_02,track_turn_02_in_deg);
        track_map_05 = generateStraigthTrack(track_ID,track_v_max,track_part_length);

        table_track_map = [track_map_01;track_map_02;track_map_03;track_map_04;track_map_05];
     case {'track5'} % track to test speed limiter
        track_ID = 5;
        
        track_map_01 = generateStraigthTrack(track_ID,108,500);
        track_map_02 = generateStraigthTrack(track_ID,36,500);
        
        table_track_map = [track_map_01;track_map_02];
    otherwise
        error('Track shape not supported');
end

% Convert table trackmap to matrix trackmap for the use in simulink
mat_track_map = tableTrackMap2matTrackMap(table_track_map);

% Init Simulation _________________________________________________________

if fix_rng   
    gnss_rng_seed = 659842;
    imu_rng_seed = 64987;
else
    gnss_rng_seed = randi(1e3);
    imu_rng_seed = randi(1e4);
end % if

if t_end == 0
    L_track = sum(table_track_map.length);
    t_end = ceil(L_track/(abs(v_train_desired_kmh)/3.6));
end % if

% Measurement and filter initializations __________________________________

[~,~,~,p_0,t_0,c_0,~,~] = calcTrackProperties(0,table_track_map.ID(1),track_rel_position_0,table_track_map,phi_track,1);

% Measurements
z_gps_0     = p_0; % in m
z_acc_0     = 0; % in m/s^2
z_gyro_0    = 0; % in rad/s
z_0_meas = [z_gps_0; z_acc_0; z_gyro_0];
sigma_w_ref = [sigma_w_gps_ref; sigma_w_gps_ref; sigma_w_acc_ref; sigma_w_gyro_ref];

% Kalman-Filter
sigma_v_kf = blkdiag(sigma_v_acc,sigma_v_gyro);
sigma_w_kf = [sigma_w_gps_kf; sigma_w_gps_kf; sigma_w_acc_kf; sigma_w_gyro_kf];
Gamma = [[1/2*T_system^2 1/2*T_system^2 1/2*T_system^2 T_system 1 0 0]', [0 0 0 0 0 T_system 1]'];

Q_kf = Gamma*sigma_v_kf.^2*Gamma';
R_kf = diag(sigma_w_kf.^2);
P_0_kf = Q_kf;

% initial state vector
x_kf_x_0     = p_0(1); % in m
x_kf_y_0     = p_0(2); % in m
x_kf_d_0     = 0; % in m
x_kf_v_0     = v_train_0; % in m/s
x_kf_a_0     = a_train_0;  % in m/s^2
x_kf_theta_0 = atan2(t_0(2),t_0(1)); % in rad
x_kf_w_0     = -x_kf_v_0*c_0; % in rad/s
x_0_kf = [x_kf_x_0; x_kf_y_0; x_kf_d_0; x_kf_v_0; x_kf_a_0; x_kf_theta_0; x_kf_w_0];

