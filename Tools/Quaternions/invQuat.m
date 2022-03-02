function qinv = invQuat(q)
% qinv = invQuat(q)
% 
%   Inverse of quaternion q
%
%   In:
%       q   quaternion
%
%   Out:
%       qinv  inverse quaternion q^-1
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 14-Apr-2020; Last revision: 14-Apr-2020

%%

qinv = transpQuat(q) / (normOfQuat(q)^2);

end % function

