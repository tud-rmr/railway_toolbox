function [x_hat,P,nu,S] = calcDiscreteKalmanFilter(u,z,Q,R,x_0,P_0,state_transition_fcn_name,measurement_fcn_name,sample_time,varargin)
% [x_hat,P,nu,S] = calcDiscreteKalmanFilter(u,z,Q,R,x_0,P_0,state_transition_fcn_name,measurement_fcn_name,sample_time)
%
% In:
%   u                           input vector
%   z                           measurement vector
%   Q                           system covariance matrix
%   R                           measurement covariance matrix
%   x_0                         previous state estimate
%   P_0                         previous state estimate covariance matrix
%   state_transition_fcn_name   name of the state transition function (This function has to provide the following arguments: in --> [x,u,sample_time], out --> [x_hat,F])
%   measurement_fcn_name        name of the measurement function (This function has to provide the following arguments: in --> [x,u,sample_time], out --> [z_hat,H])
%   sample_time                 discrete sample time in seconds
%   varargin                    additional (optional) input argument: residuum calculation function
%
% Out:
%   x_hat                       new state estimate
%   P                           new state estimate covariance matrix
%   nu                          measurement residuum
%   S                           measurement residuum covariance matrix
%

%% Initialization and checks

symmetry_round_tolerance = 1e-9;

% Checks __________________________________________________________________

if (sample_time < 0)
    error('calcDiscreteKalmanFilter: Wrong sample time!');
end % if

if ~isPositiveDefinite(Q,symmetry_round_tolerance)
    error('calcDiscreteKalmanFilter: ''Q'' is not positive semidefinite');
end % if

if ~isPositiveDefinite(R,symmetry_round_tolerance)
    error('calcDiscreteKalmanFilter: ''R'' is not positive semidefinite');
end % if

if ~isPositiveDefinite(P_0,symmetry_round_tolerance)
    error('calcDiscreteKalmanFilter: ''P_0'' is not positive semidefinite');
end % if

%% Measurement selector

valid_measurement_selector = ((z(:) ~= 0) & (diag(R) ~= 0));

%% Calculations

% Prediction ______________________________________________________________
[x_hat,F] = eval([state_transition_fcn_name,'(x_0,z,u,sample_time);']);
P = F*P_0*F.' + Q;
P = 1/2*(P+P.');

if ~isPositiveDefinite(P,symmetry_round_tolerance)
    P = nearestSPD(P);
    % error('calcDiscreteKalmanFilter: ''P'' is not positive semidefinite');
end % if

% Correction ______________________________________________________________
if any(valid_measurement_selector) % Valid measurement available
    [z_hat,H] = eval([measurement_fcn_name,'(x_hat,z,u,sample_time);']);
    
    z_hat = z_hat(valid_measurement_selector);
    H = H(valid_measurement_selector,:);
    R = R(valid_measurement_selector,valid_measurement_selector);
    z = z(valid_measurement_selector);
        
    if nargin > 9 && ~isempty(varargin{1})
        nu = eval([varargin{1},'(z,z_hat);']);
    else
        nu = z - z_hat;
    end % if    
    nu(abs(nu)<1e-12) = 0;
    
    S = H*P*H.' + R;
    S = 1/2*(S+S.');
    
    if ~isPositiveDefinite(S,symmetry_round_tolerance)
        S = nearestSPD(S);
        %error('calcDiscreteKalmanFilter: ''S'' is not positive semidefinite');
    end % if
            
    K = P*H'*invChol_mex(S);
    %K = P*H'*S^-1;

    x_hat = x_hat + K*nu;
    A = eye(length(K))-K*H;
    P = A*P*A.' + K*R*K.';
    P = 1/2*(P+P.');
else % No valid measurement available
    nu = zeros(size(z));   
    S = zeros(length(z));
end % if

end % function

