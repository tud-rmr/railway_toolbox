clear all
close all
clc

%%

m_ref = 1;
n_ref = 1;

sigma_meas = 5;

x_ref = (-10:0.01:10)';
y_ref = m_ref*x_ref + repmat(n_ref,length(x_ref),1);

x_meas = x_ref;
y_meas = y_ref + sigma_meas*randn(length(y_ref),1);

%%

[m_calc, n_calc] = straightLineRegression([x_meas;y_meas])
[m_calc, n_calc] = straightLineRegression([x_meas;y_meas],[x_ref(1) y_ref(1)])
y_calc = m_calc*x_meas + repmat(n_calc,length(x_meas),1);

%%

plot(x_ref,y_ref,'b','LineWidth',2); hold on; grid on;
plot(x_meas,y_meas,'k.','MarkerSize',5);
plot(x_meas,y_calc,'r','LineWidth',2);
