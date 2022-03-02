clear all
close all
clc

%%

state_transition_fcns = {'test_libMdl_''Imm_stateTransition Fcn1','test_libMdl_Imm_stateTransition Fcn02'};
measurement_fcns = {'test_libMdl_Imm_measurement Fcn1','test_libMdl_Imm_measurement Fcn2'};

[uint8_state_transition_fcns,uint8_measurement_fcns] = simFcn_Imm_MaskInit(state_transition_fcns,measurement_fcns)