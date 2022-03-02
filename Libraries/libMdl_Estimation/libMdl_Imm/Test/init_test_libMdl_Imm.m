clear all
close all
clc

%%

% Example from:
% "Y. Bar-Shalom et al., Estimation with applications to tracking and
% navigation: theory algorithms and software, 2001" Section 5.3, P. 218ff.

T = 0.5; % sample time in seconds

Gamma = [1/2*T^2; T];

sigma_v = 1; % standard deviation of system noise
sigma_w = 1; % standard deviation of measurement noise

Q1 = Gamma*sigma_v^2*Gamma';
Q2 = Q1;
Q = cat(3,Q1,Q2);
R = sigma_w^2;

x_01 = [0;0];
x_02 = [0;10]; % reference is also initialized with these values
x_0 = [x_01,x_02]; 
P_0 = Q;

Pi = [0.8 0.2; ... 
      0.2 0.8];
mu_0 = [0.8; 0.2];

state_transition_fcns = {'test_libMdl_Imm_stateTransitionFcn1','test_libMdl_''Imm_stateTransition Fcn02'};
measurement_fcns = {'test_libMdl_Imm_measurementFcn1','test_libMdl_''Imm_measurement Fcn02'};
