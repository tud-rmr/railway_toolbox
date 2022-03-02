function qnorm = normOfQuat(q)
% qnorm = normOfQuat(q)
% 
%   Norm of quaternion q
%
%   In:
%       q   quaternion
%
%   Out:
%       qinv  norm of quaternion |q|
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 14-Apr-2020; Last revision: 30-Apr-2020

%% 

qnorm = sqrt( q(1)^2 + q(2)^2 + q(3)^2 + q(4)^2 );

end % function

