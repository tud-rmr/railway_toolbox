function [x_k_hat,F_k] = test_libMdl_KalmanFilter_stateTransitionFcn(x_k,z_k,u_k,sample_time)
% [x_k_new,F_k] = test_libMdl_KalmanFilter_stateTransitionFcn(x_k,u_k,sample_time)

T = sample_time;

F_k = [1 T;0 1];
x_k_hat = F_k*x_k;

end

