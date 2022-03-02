function [x_hat,F] = simFcn_Imm_stateTransitionFcnWrapper(state_transition_fcn_name,x,u,sample_time)
% [x_hat,F_k] = simFcn_Imm_stateTransitionFcnWrapper(state_transition_fcn_name,x,u,sample_time)
%
% This is function is intended for the use in the Simulink-Matlab-Function
% <<simFcn_ImmFilterBank>>. It is necesseray to enable the dynamic call of
% the function stored in <<state_transition_fcn_name>>, because this 
% wrapper function can staticly be declared as extrinsic.

[x_hat,F] = eval([state_transition_fcn_name,'(x,u,sample_time);']);

end

