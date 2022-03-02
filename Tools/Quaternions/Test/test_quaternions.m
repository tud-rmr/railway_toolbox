% Test quaternion functions
%
%   Other m-files required: transformVect, eulerToQuaternion
%   MAT-files required: none
%
%   See also: importRawData

%   Author: Hanno Winter
%   Date: 14-Apr-2020; Last revision: 14-Apr-2020

%%

clear all
close all
clc

%% Rotate a random vector with a quaternions and euler angles

% Define __________________________________________________________________

e = [0 0 150]'; % euler angles in degree [roll,pitch,yaw]'
norm_of_q = 1;

% Init ____________________________________________________________________

v = rand(3,1);
v = [-0.1;1;0];
e = e.*pi/180;

% Rotation matrix with euler angles from body to reference axis
% See: J. Wendel : Integrierte Navigationssysteme, S. 37, 2007
C = [ ...
      cos(e(2))*cos(e(3)), -cos(e(1))*sin(e(3)) + sin(e(1))*sin(e(2))*cos(e(3)),  sin(e(1))*sin(e(3))+cos(e(1))*sin(e(2))*cos(e(3)); ...
      cos(e(2))*sin(e(3)),  cos(e(1))*cos(e(3)) + sin(e(1))*sin(e(2))*sin(e(3)), -sin(e(1))*cos(e(3))+cos(e(1))*sin(e(2))*sin(e(3)); ...
               -sin(e(2)),                             sin(e(1))*cos(e(2)),                            cos(e(1))*cos(e(2))  ...
     ];

% Tests ___________________________________________________________________

% Transformation from euler to quaternion 
q = norm_of_q*eulerToQuat(e);
% q = [.288;0.00619;-0.00175;-0.958];
e_from_q = quatToEuler(q);

if (normOfQuat(q)-norm_of_q) > 1e-15
    warning('test_quaternions: There seems to be an error in ''normQuat''!');
end % if

if norm(e_from_q - e) > 1e-15
    warning('test_quaternions: There seems to be an error in ''eulerToQuat'' or ''quatToEuler''!');
end % if

% Vector transformation with quaternion
v_new_q = transformVect(v,q);
v_new_e = C*v;

if norm(v_new_q - v_new_e) > 1e-15
    warning('test_quaternions: There seems to be an error in ''transformVect''!');
end % if

% Plot ____________________________________________________________________

figure_name = ['Test Quaternion functions'];
close(findobj('Type','figure','Name',figure_name));
figure('Name',figure_name); hold on; grid on;

clear h_plot    
h_plot = gobjects(0);  

h_plot(end+1) = plot3([0 v(1)],[0 v(2)],[0 v(3)],'k-','LineWidth',1.5,'MarkerSize',10,'DisplayName','original vector');
h_plot(end+1) = plot3([0 v_new_q(1)],[0 v_new_q(2)],[0 v_new_q(3)],'b-','LineWidth',1.5,'MarkerSize',10,'DisplayName','new vector by q-transform');    
h_plot(end+1) = plot3([0 v_new_e(1)],[0 v_new_e(2)],[0 v_new_e(3)],'c--','LineWidth',1.5,'MarkerSize',10,'DisplayName','new vector by e-transform');    

legend(h_plot);
xlabel('x')
ylabel('y')
zlabel('z')

axis equal
