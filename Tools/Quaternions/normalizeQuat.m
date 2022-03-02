function q_normalized = normalizeQuat(q)
% q_normalized = normalizeQuat(q)
% 
%   Returns the normalzied quaternion of q
%
%   In:
%       q               quaternion
%
%   Out:
%       q_normalized    normalized quaternion q
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 30-Apr-2020; Last revision: 30-Apr-2020

%% 

q_normalized = q / normOfQuat(q);

end % function

