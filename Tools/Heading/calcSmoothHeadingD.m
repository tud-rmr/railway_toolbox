function hs = calcSmoothHeadingD(delta_y,delta_x)
% hs = calcSmoothHeadingD(delta_y,delta_x)
% 
% Calculate smooth heading vector from delta_y and delta_x data.
%
%   In:
%       delta_y   delta y data array
%       delta_x   delta x data array
% 
%   Out:
%       hs        smooth heading in degree
%
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 23-Nov-2020; Last revision: 23-Nov-2020

%% Calculations

h = atan2d(delta_y,delta_x);
hs = smoothenHeadingD(h);


% h(h<0) = h(h<0) + 360;
% dh = diff(h);

% dh = zeros(size(h));
% i_0 = find(~isnan(h),1)+1;
% for i = i_0:length(h)   
%     dh(i) = h(i)-h(i-1);
%     
%     if (abs(dh(i))>180) && (dh(i)>180)
%         dh(i) = dh(i)-360;
%     end % if
%     
%     if (abs(dh(i))>180) && (dh(i)<180)
%         dh(i) = dh(i)+360;
%     end % if
% end % if
% h = h(i_0)+cumsum(dh);


% dh_selector1 = (abs(dh)>180) & (dh>180);
% dh_selector2 = (abs(dh)>180) & (dh>180);
% dh(dh_selector1) = dh(dh_selector1) - 360;
% dh(dh_selector2) = dh(dh_selector2) + 360;
% 
% h = h(find(~isnan(h),1))+cumsum(dh);

end % function 