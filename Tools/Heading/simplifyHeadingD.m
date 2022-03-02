function hs = simplifyHeadingD(h,h_mod)
% hs = simplifyHeadingD(h,h_mod)
% 
% Simplify heading
%
%   In:
%       h       heading array
%       h_mod   simplification mode (either '180' or '360' degrees)
% 
%   Out:
%       hs      simplified heading in degree
%
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 23-Nov-2020; Last revision: 23-Nov-2020

%% Calculations

hs = smoothenHeadingD(h);
hs = mod(hs,360);

if strcmp(h_mod,'180')
    hs(hs>180) = hs(hs>180)-360;
end % if

end % function 