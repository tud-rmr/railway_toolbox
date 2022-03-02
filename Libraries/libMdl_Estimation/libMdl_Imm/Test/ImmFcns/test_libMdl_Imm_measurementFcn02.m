function [z_k_hat,H_k] = test_libMdl_KalmanFilter_measurementFcn(x_k,z_k,u_k,sample_time)
% [z_k_hat,H_k] = test_libMdl_KalmanFilter_measurementFcn(x_k,u_k,sample_time)

H_k = [1 0];
z_k_hat = H_k*x_k;

end

