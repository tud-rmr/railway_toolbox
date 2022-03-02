function [c_n,t_n,curv_n,radius_n] = constantArcTrackElement(l,R,rot_angle,trans_vector)
% function [c_n,t_n,curv_n,radius_n] = constantArcTrackElement(l,R,rot_angle,trans_vector)
%
% R:    positiv --> right turn in driving direction
%       negativ --> left turn in driving direction
% For definition see: Volker Matthews. Bahnbau (7. Auflage), S. 99

%% Initialization and checks

% Checks___________________________________________________________________

if nargin == 2
    rot_angle = 0;
    trans_vector = [0;0];
elseif nargin == 3
    trans_vector = [0;0];
end % end if

% Initialization___________________________________________________________

direction_flag = [1;-sign(R)];

rotation_matrix = @(phi) [cos(phi/360*2*pi) -sin(phi/360*2*pi);sin(phi/360*2*pi) cos(phi/360*2*pi)];
circle_fcn = @(l,R) abs(R) * [sin(l./abs(R)); (1-cos(l./abs(R)))];
circle_derivative_fcn = @(l,R) [cos(l./abs(R)); sin(l./abs(R))];

%% Calculations

% c_n = zeros(2,length(l));
% t_n = c_n;
c_n = direction_flag .* circle_fcn(l,R);
t_n = direction_flag .* circle_derivative_fcn(l,R);
curv_n = 1/R*ones(1,length(l));
radius_n = R*ones(1,length(l));

% for l_index = 1:length(l)
%     c_n(:,l_index) = direction_flag .* circle_fcn(l(l_index),R);
%     t_n(:,l_index) = direction_flag .* circle_derivative_fcn(l(l_index),R);
% end % for l_index

% Adjust orientation_______________________________________________________

c_n = rotation_matrix(rot_angle)*c_n + trans_vector;
t_n = rotation_matrix(rot_angle)*t_n;

end % end function constantArcTrackElement
