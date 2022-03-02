function [polar_std_curve,cart_std_curve] = getStandardDeviationCurve(S,std_interval,resolution)
% [polar_std_curve,cart_std_curve] = getStandardDeviationCurve(S,std_interval,resolution)
%
% In:
%   S               covariance matrix
%   std_interval    standard deviation for which the curve should be drawn
%   resolution      number of points that the standard deviational curve consist of
%
% Out:
%   polar_std_curve     2-D data: standard deviational curve in polar coordinates
%                       1-D data: length of errorbar corresponding to the standard deviation (in one direction)
%   cart_std_curve      2-D data: standard deviational curve in cartesian coordinates
%                       1-D data: length of errorbar corresponding to the standard deviation (in one direction)
%
% See: Jianxin Gong, "Clarifying the standard deviational ellipse"; Journal: Geographical Analysis, 2002
%

%% Initialization and checks

if length(S) > 2 || size(S,1) ~= size(S,2)
    error('Covariance matrix ''S'' is not valid!');
end
   
%% Calculations 

if length(S) > 1
    theta_in_deg = linspace(0,360,resolution);
    [rho_std_curve,cart_std_curve,~] = calcStandardDeviationCurve(S,theta_in_deg,std_interval);
    polar_std_curve = [theta_in_deg;rho_std_curve];
else
    theta_in_deg = [];
    [polar_std_curve,~,~] = calcStandardDeviationCurve(S,theta_in_deg,std_interval);
    cart_std_curve = polar_std_curve;
end % if

end % function