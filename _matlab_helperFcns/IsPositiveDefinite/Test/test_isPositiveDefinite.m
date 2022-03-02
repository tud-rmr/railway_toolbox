clear all
close all
clc

%%

A = [1 2 3;0 5 8;0 0 10]; % not positive definite
B = [-1 2 3;2 5 8;3 8 10]; % positive definite

q_A = isPositiveDefinite(A,1e-14)
q_B = isPositiveDefinite(B,1e-14)