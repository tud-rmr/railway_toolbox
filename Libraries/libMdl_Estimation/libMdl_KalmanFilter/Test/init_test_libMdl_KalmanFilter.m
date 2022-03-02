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

Q = Gamma*sigma_v^2*Gamma';
R = sigma_w^2;

x_0 = [50;10];
P_0 = Q;