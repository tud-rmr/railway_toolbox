close all
clear all
clc

%% Settings

% Simulation parameters ___________________________________________________

t_end = 0;         % 0 --> automatic (approximately according to track length)
                   % t --> time in sec
% Data-Generator __________________________________________________________

% Vehicle
front_track_id = 1;
train_length = 400; % in m
v_train_front = 36; % in km/h
a_train_front = [0;0;0]; % in m/s^2

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
phi_track = 30; % in degree
track_radius_01 = 900; % in m
track_radius_02 = 300; % in m
track_v_max = 160; % in km/h
track_turn_01_in_deg = -45; % in degree
track_turn_02_in_deg = 60; % in degree

track_map_01 = generateStraigthTrack(1,track_v_max,500);
track_map_02 = generateTurnTrack(2,track_v_max,track_radius_01,track_turn_01_in_deg);    
track_map_03 = generateStraigthTrack(2,track_v_max,500);
track_map_04 = generateTurnTrack(3,track_v_max,track_radius_02,track_turn_02_in_deg);
track_map_05 = generateStraigthTrack(4,track_v_max,500);

table_track_map = [track_map_01;track_map_02;track_map_03;track_map_04;track_map_05];
% 
% track_map_01 = generateStraigthTrack(1,160,250);
% track_map_02 = generateStraigthTrack(2,160,125);    
% track_map_03 = generateStraigthTrack(2,160,125);
% track_map_04 = generateStraigthTrack(3,160,250);
% 
% table_track_map = [track_map_01;track_map_02;track_map_03;track_map_04];
mat_track_map = tableTrackMap2matTrackMap(table_track_map); % Convert table trackmap to matrix trackmap for the use in simulink

% Init Simulation _________________________________________________________

if t_end == 0
    L_track = sum(table_track_map.length);
    t_end = ceil(L_track/(abs(v_train_front)/3.6));
end % if



