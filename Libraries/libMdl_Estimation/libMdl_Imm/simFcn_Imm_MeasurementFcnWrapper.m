function [z_hat,H] = simFcn_Imm_MeasurementFcnWrapper(measurement_fcn_name,x,u,sample_time)
% [z_hat,H] = simFcn_Imm_MeasurementFcnWrapper(measurement_fcn_name,x,u,sample_time)
%
% This is function is intended for the use in the Simulink-Matlab-Function
% <<simFcn_ImmFilterBank>>. It is necesseray to enable the dynamic call of
% the function stored in <<measurement_fcn_name>>, because this wrapper
% function can staticly be declared as extrinsic.


[z_hat,H] = eval([measurement_fcn_name,'(x,u,sample_time);']);

end

