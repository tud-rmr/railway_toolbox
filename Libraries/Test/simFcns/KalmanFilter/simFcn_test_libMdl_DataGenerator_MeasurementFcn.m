function [z_k_hat,H_k] = simFcn_test_libMdl_DataGenerator_MeasurementFcn(x_k,z,u_k,sample_time)

H_k = [1, 0, 0, 0, 0, 0, 0; ... 
       0, 1, 0, 0, 0, 0, 0; ... 
       0, 0, 0, 0, 1, 0, 0; ...
       0, 0, 0, 0, 0, 0, 1];
z_k_hat = H_k*x_k;

end

