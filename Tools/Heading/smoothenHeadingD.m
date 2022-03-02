function hs = smoothenHeadingD(h)
% hs = smoothenHeadingD(h)
% 
% Smoothen heading (in degree) with overflows either at 180 or 360 degrees.
%
%   In:
%       h   heading (in degree) array
% 
%   Out:
%       hs  smooth heading in degree
%
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 23-Nov-2020; Last revision: 23-Nov-2020

%% Calculations

h(h<0) = h(h<0)+360;

dh = [0;diff(h(:))];
dh(isnan(dh)) = 0;

dh_selector1 = (abs(dh)>180) & (dh>180);
dh_selector2 = (abs(dh)>180) & (dh<180);
dh(dh_selector1) = dh(dh_selector1) - 360;
dh(dh_selector2) = dh(dh_selector2) + 360;

hs = mod(h(find(~isnan(h),1)),360) + cumsum(dh);


% dh = zeros(size(h));
% i_0 = find(~isnan(h),1);
% for i = i_0+1:length(h)
%     dh(i) = h(i)-h(i-1);
%     
%     if (abs(dh(i)) > 180) && (dh(i) > 180)
%         dh(i) = dh(i)-360;
%     end % if
%     
%     if (abs(dh(i)) > 180) && (dh(i) < 180)
%         dh(i) = dh(i)+360;
%     end % if
%     
% end % for i
% hs = mod(h(i_0),360) + cumsum(dh);

end % function 