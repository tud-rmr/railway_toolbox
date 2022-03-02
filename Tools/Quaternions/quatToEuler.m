function e = quatToEuler(q)
% e = quatToEuler(q)
% 
%   Transform quaternion to euler angles, assuming the rotation order ZYX
%
%   In:
%       q   quaternion
%
%   Out:
%       e   euler angles [roll,pitch,yaw]' in radian
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 14-Apr-2020; Last revision: 30-Apr-2020

%% 

norm_q = normOfQuat(q);
if abs(norm_q-1) > 1e-15
    q = q/norm_q;
end % if

e = [ ...
      atan2( 2*(q(3)*q(4) + q(1)*q(2)) , q(1)^2 - q(2)^2 - q(3)^2 + q(4)^2 ); ...      
                           asin( max(min(-2*(q(2)*q(4) - q(1)*q(3)),1),-1) ); ...
      atan2( 2*(q(2)*q(3) + q(1)*q(4)) , q(1)^2 + q(2)^2 - q(3)^2 - q(4)^2 )  ... 
    ];
% e = mod(e,2*pi);


end % function

