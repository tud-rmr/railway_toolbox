function [uint8_state_transition_fcns,uint8_measurement_fcns,uint8_residuum_fcns] = simFcn_Imm_MaskInit(cellstr_state_transition_fcns,cellstr_measurement_fcns,cellstr_residuum_fcns)

% Checks and Initialization _______________________________________________

if any(size(cellstr_state_transition_fcns) ~= size(cellstr_measurement_fcns))
    error('libMdl_Imm: Dimension mismatsch between ''state transition functions list'' and ''measurment functions list''!');
end % if

% uint8_state_transition_fcns = cell(length(cellstr_state_transition_fcns),1);
% uint8_measurement_fcns = cell(length(cellstr_measurement_fcns),1);
temp_state_transition_fcns = cell(length(cellstr_state_transition_fcns),1);
temp_measurement_fcns = cell(length(cellstr_measurement_fcns),1);
temp_residuum_fcns = cell(length(cellstr_residuum_fcns),1);

% Calculations ____________________________________________________________

% remove unwanted characters in the function names (space, apostrophs, ...)
temp_state_transition_fcns(:,1) = regexprep(cellstr_state_transition_fcns,'[\s'']','');
temp_measurement_fcns(:,1) = regexprep(cellstr_measurement_fcns,'[\s'']','');
temp_residuum_fcns(:,1) = regexprep(cellstr_residuum_fcns,'[\s'']','');

% pad with spaces to allow conversion from cell to matrix (this is 
% necessary for simulink to be able to work with the variables)
temp_state_transition_fcns = pad(temp_state_transition_fcns);
temp_measurement_fcns = pad(temp_measurement_fcns);  
temp_residuum_fcns = pad(temp_residuum_fcns); 

% Convert to uint8 for simulink
for i = 1:length(cellstr_state_transition_fcns) 
    temp_state_transition_fcns{i,:} = uint8(temp_state_transition_fcns{i});
    temp_measurement_fcns{i,:} = uint8(temp_measurement_fcns{i});
    temp_residuum_fcns{i,:} = uint8(temp_residuum_fcns{i});
end % for i

% Convert cell to matrix
uint8_state_transition_fcns = cell2mat(temp_state_transition_fcns);
uint8_measurement_fcns = cell2mat(temp_measurement_fcns);
uint8_residuum_fcns = cell2mat(temp_residuum_fcns);

end % function

