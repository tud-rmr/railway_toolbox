function [x_hat,F] = stateTransitionFcn(x,z,u,sample_time)

F = [1 sample_time;0 1];
x_hat = F*x;

end

