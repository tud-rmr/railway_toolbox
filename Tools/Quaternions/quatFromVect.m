function q = quatFromVect(u,v)
% q = quatFromVect(u,v)
% 
%   Calculates the shortest path quaternion transforming 
%   vector u to vector v.
%
%   This function is taken from:
%       - http://lolengine.net/blog/2013/09/18/beautiful-maths-quaternion-from-vectors
%       - http://lolengine.net/blog/2014/02/24/quaternion-from-two-vectors-final
%   Maybe also helpful is:
%       - https://stackoverflow.com/questions/1171849/finding-quaternion-representing-the-rotation-from-one-vector-to-another
%
%   Unfortunatly, I couldn't find a better reference. This procedure seems
%   to be a quite common approach as searching the internet for the term 
%   "quaternion from two vectors" reveals.
%
%   In:
%       u   3D vector
%       v   3D vector
%
%   Out:
%       q   quaternion representing the rotation from u to v
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter (original code from http://lolengine.net/blog/author/sam)
%   Date: 30-Apr-2020; Last revision: 08-Dec-2020

%%

norm_u_norm_v = sqrt(dot(u,u) * dot(v,v));
real_part = norm_u_norm_v + dot(u,v);

if 0 == norm_u_norm_v
    q = [1;0;0;0];
    return
end % if

if (real_part < 1e-6 * norm_u_norm_v)
    % If u and v are exactly opposite, rotate 180 degrees
    % around an arbitrary orthogonal axis. Axis normalisation
    % can happen later, when we normalise the quaternion.
    
    real_part = 0;    
    if abs(u(1)) > abs(u(3))
        w = [-u(2); u(1); 0];
    else
        w = [0; -u(3); u(2)];
    end % if
    
else
    % Otherwise, build quaternion the standard way.
    
    w = cross(u,v);
    
end % if

q = normalizeQuat([real_part;w]);

end % function

