function qt = transpQuat(q)
% qr = multQuat(q,r)
% 
%   Transpose of quaternion q
%
%   In:
%       q   quaternion
%
%   Out:
%       qt  transposed quaternion q (qt = q')
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 14-Apr-2020; Last revision: 14-Apr-2020

%%

qt = [q(1) -q(2) -q(3) -q(4)]';

end % function

