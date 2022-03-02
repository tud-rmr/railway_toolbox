
function v_new = transformVect(v,q)
% v_new = transformVect(v,q)
% 
%   Transform vector v with quaternion q
%
%   In:
%       v       vector
%       q       quaternion
%
%   Out:
%       v_new   transformed vector
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 14-Apr-2020; Last revision: 14-Apr-2020

%% 

norm_q = normOfQuat(q);
if abs( norm_q - 1 ) < 1e-15
    v_new = multQuat(q,multQuat([0;v(:)],transpQuat(q)));
else
    v_new = multQuat(q,multQuat([0;v(:)],invQuat(q)));
end % if

v_new = v_new(2:4);

end % function

