function q = eulerToQuat(e)
% q = eulerToQuat(e)
% 
%   Transform euler angles to quaternion, assuming the rotation order ZYX
%
%   In:
%       e   euler angles [roll,pitch,yaw]' in radian
%
%   Out:
%       q   quaternion
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 14-Apr-2020; Last revision: 30-Apr-2020

%% 

r = e(1);
p = e(2);
y = e(3);

q = [ ... 
       cos(r/2)*cos(p/2)*cos(y/2) + sin(r/2)*sin(p/2)*sin(y/2); ...
       sin(r/2)*cos(p/2)*cos(y/2) - cos(r/2)*sin(p/2)*sin(y/2); ...
       cos(r/2)*sin(p/2)*cos(y/2) + sin(r/2)*cos(p/2)*sin(y/2); ...
       cos(r/2)*cos(p/2)*sin(y/2) - sin(r/2)*sin(p/2)*cos(y/2)  ...
    ];

end % function

