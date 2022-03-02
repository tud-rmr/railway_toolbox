function [polar_err_ellipse,cart_err_ellipse] = getErrorEllipse(S,conf_interval,resolution)
% [polar_err_ellipse,cart_err_ellipse] = getErrorEllipse(S,conf_interval,resolution)
%
% In:
%   S               covariance matrix
%   conf_interval   probabilty for the points of the distribution to be in the error interval, given as 0...1
%   resolution      number of points that the error ellipse should consist of
%
% Out:
%   polar_err_ellipse   2-D data: error ellipse in polar coordinates
%                       1-D data: length of errorbar (in one direction)
%   cart_err_ellipse    error ellipse in cartesian coordinates
%                       1-D data: length of errorbar (in one direction)
%

%% Initialization and checks

if length(S) > 2 || size(S,1) ~= size(S,2)
    error('Covariance matrix ''S'' is not valid!');
end
   
%% Calculations 

if length(S) > 1
    theta_in_deg = linspace(0,360,resolution);
    [rho_err_ellipse,cart_err_ellipse,~] = calcErrorEllipse(S,theta_in_deg,conf_interval);
    polar_err_ellipse = [theta_in_deg;rho_err_ellipse];
else
    theta_in_deg = [];
    [polar_err_ellipse,~,~] = calcErrorEllipse(S,theta_in_deg,conf_interval);
    cart_err_ellipse = polar_err_ellipse;
end % if

end % function

