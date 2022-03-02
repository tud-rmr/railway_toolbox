close all
clear all
clc

%% Settings

% Simulation parameters ___________________________________________________

t_end = 120;         % 0 --> automatic (approximately according to track length)
                     % t --> time in sec
T_system = 0.5;      % sample time in sec

% Data-Generator __________________________________________________________

% Vehicle
max_train_acc = [-2 1.5]; % [max_decceleration max_acceleration] in m/s^2
v_train_desired_kmh  = 200; % desired vehicle speed in km/h
track_id_0           = 1;
track_rel_position_0 = 0; % in m
v_train_0            = v_train_desired_kmh/3.6; % in m/s
a_train_0            = 0; % in m/s^2

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

% combination of various track types
track_ID = 1;
track_radius_01 = 900; % in m
track_radius_02 = 300; % in m
track_part_length = 1000; % in m
track_v_max = 160; % in km/h
track_turn_01_in_deg = -45; % in degree
track_turn_02_in_deg = 60; % in degree
phi_track = 30; % in degree

track_map_01 = generateStraigthTrack(track_ID,track_v_max,track_part_length);
track_map_02 = generateTurnTrack(track_ID,track_v_max,track_radius_01,track_turn_01_in_deg);    
track_map_03 = generateStraigthTrack(track_ID,track_v_max,track_part_length);
track_map_04 = generateTurnTrack(track_ID,track_v_max,track_radius_02,track_turn_02_in_deg);
track_map_05 = generateStraigthTrack(track_ID,track_v_max,track_part_length);

table_track_map = [track_map_01;track_map_02;track_map_03;track_map_04;track_map_05];
mat_track_map = tableTrackMap2matTrackMap(table_track_map); % Convert table trackmap to matrix trackmap for the use in simulink

% Init Simulation _________________________________________________________

if t_end == 0
    L_track = sum(table_track_map.length);
    t_end = ceil(L_track/(abs(v_train_desired_kmh)/3.6));
end % if



