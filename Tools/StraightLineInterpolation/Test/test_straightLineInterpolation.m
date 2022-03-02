clear all
close all
clc

%%

m_ref = 1;
n_ref = 0;

sigma_meas = 5;

x_ref = (0:0.1:10)';
y_ref = m_ref*x_ref + repmat(n_ref,length(x_ref),1);

x_meas = x_ref;
y_meas = y_ref + sigma_meas*randn(length(y_ref),1);

%%

l = (0:2:15)';
[s,t] = straightLineInterpolation([x_meas;y_meas],[x_ref(1);y_ref(1)],l);


%%

plot(x_ref,y_ref,'b','LineWidth',2); hold on; grid on;
plot(x_meas,y_meas,'k.','MarkerSize',5);
plot(s(1,:),s(2,:),'r-o','LineWidth',2,'MarkerSize',10);
