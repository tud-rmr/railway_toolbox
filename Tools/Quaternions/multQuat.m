function qr = multQuat(q,r)
% qr = multQuat(q,r)
% 
%   Multiplication of two quaternions q and r
%
%   In:
%       q   quaternion
%       r   quaternion
%
%   Out:
%       qr  result of multiplication qr = q*r
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 14-Apr-2020; Last revision: 14-Apr-2020

%%

qr = [ ...
       q(1) -q(2) -q(3) -q(4); ...
       q(2)  q(1) -q(4)  q(3); ...
       q(3)  q(4)  q(1) -q(2); ...
       q(4) -q(3)  q(2)  q(1)  ...
     ] * r;

end % function

