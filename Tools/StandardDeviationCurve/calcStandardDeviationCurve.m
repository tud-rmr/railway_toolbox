function [rho_std_curve,cart_std_curve,theta_0] = calcStandardDeviationCurve(S,theta_in_deg,std_interval)
% [rho_std_curve,cart_std_curve,theta_0] = calcStandardDeviationCurve(S,theta_in_deg,std_interval)
%
% In:
%   S               covariance matrix
%   theta_in_deg    direction angle for which the standard deviational curve should be calculated (vector mode possible)
%   std_interval    standard deviation for which the curve should be drawn
%
% Out:
%   rho_std_curve     2-D data: radius of the standard deviational curve for the angle corresponding to the input 'theta_in_deg'
%                     1-D data: length of errorbar corresponding to the standard deviation (in one direction)
%   cart_std_curve    2-D data: standard deviational curve point(s) in cartesian coordinates
%                     1-D data: empty
%   theta_0           2-D data: rotation angle of the standard deviational curve
%                     1-D data: empty
%
% See: Jianxin Gong, "Clarifying the standard deviational ellipse"; Journal: Geographical Analysis, 2002
%


%% Initialization and checks

if length(S) > 2 || size(S,1) ~= size(S,2)
    error('Covariance matrix ''S'' is not valid!');
end

if size(theta_in_deg,2) < size(theta_in_deg,1)
    theta_in_deg = theta_in_deg';
end % if

%% Calculations for length(S) == 2

if length(S) == 2
    % z = max(norminv([(1-conf_interval)/2 conf_interval+(1-conf_interval)/2],0,1));
    z = std_interval;

    [V,D] = eig(S);
    [lambda,lambda_index] = sort(diag(D),'descend');
    v_lambda = V(:,lambda_index);

    theta_0 = atand(v_lambda(2,1)/v_lambda(1,1));

    rho_std_curve = zeros(1,length(theta_in_deg));
    for theta_index = 1:length(theta_in_deg)
        gamma = theta_in_deg(theta_index)-theta_0;
        rho_std_curve(theta_index) = z*sqrt(abs(lambda(1))*cosd(gamma)^2+abs(lambda(2))*sind(gamma)^2);
    end % for theta_index
    
    cart_std_curve = zeros(2,length(theta_in_deg));    
    [cart_std_curve(1,:),cart_std_curve(2,:)] = pol2cart(theta_in_deg./360*2*pi,rho_std_curve);
end % if

%% Calculations for length(S) == 1

if length(S) == 1
    % z = max(norminv([(1-conf_interval)/2 conf_interval+(1-conf_interval)/2],0,1));
    z = std_interval;
    
    rho_std_curve = z*sqrt(S(1,1));
    theta_0 = [];    
    cart_std_curve = [];
end % if

end % function