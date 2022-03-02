function [c_n,t_n,curv_n,radius_n] = straightLineTrackElement(l,rot_angle,trans_vector)
% function [c_n,t_n,curv_n,radius_n] = straightLineTrackElement(l,rot_angle,trans_vector)

% Checks___________________________________________________________________

if nargin == 1
    rot_angle = 0;
    trans_vector = [0;0];
elseif nargin == 2
    trans_vector = [0;0];
end % end if

% Initialization___________________________________________________________

rotation_matrix = @(phi) [cos(phi/360*2*pi) -sin(phi/360*2*pi);sin(phi/360*2*pi) cos(phi/360*2*pi)];

%% Calculations

c_n = [l;zeros(1,length(l))];
t_n = [ones(1,length(l));zeros(1,length(l))];
curv_n = zeros(1,length(l));
radius_n = zeros(1,length(l));

% Adjust orientation_______________________________________________________

c_n = rotation_matrix(rot_angle)*c_n + trans_vector;
t_n = rotation_matrix(rot_angle)*t_n;

end % end function straightLineTrackElement

