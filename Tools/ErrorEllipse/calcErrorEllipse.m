function [rho_err_ellipse, cart_err_ellipse, theta_0] = calcErrorEllipse(S,theta_in_deg,conf_interval)
% [rho_err_ellipse, cart_err_ellipse, theta_0] = calcErrorEllipse(S,theta_in_deg,conf_interval)
%
% In:
%   S               covariance matrix
%   theta_in_deg    direction angle for which the error interval should be calculated (vector mode possible)
%   conf_interval   probabilty for the points of the distribution to be in the error interval, given as 0...1
%
% Out:
%   rho_err_ellipse     2-D data: radius of the error ellipse for the angle corresponding to the input 'theta_in_deg'
%                       1-D data: length of errorbar (in one direction)
%   cart_err_ellipse    2-D data: error ellipse point(s) in cartesian coordinates
%                       1-D data: empty
%   theta_0             2-D data: rotation angle of the error ellipse
%                       1-D data: empty
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
    z = chi2inv(conf_interval,length(S));

    [V,D] = eig(S);
    [lambda,lambda_index] = sort(diag(D),'descend');
    v_lambda = V(:,lambda_index);

    theta_0 = atand(v_lambda(2,1)/v_lambda(1,1));

    rho_err_ellipse = zeros(1,length(theta_in_deg));
    theta = rho_err_ellipse;
    for theta_index = 1:length(theta_in_deg)
        gamma = theta_in_deg(theta_index)-theta_0;
        a =  sqrt(z*abs(lambda(1)));
        b =  sqrt(z*abs(lambda(2)));

        if a == 0 && mod(gamma+90,180)==0
            rho_err_ellipse(theta_index) = abs(b/sind(gamma));
        elseif b == 0 && mod(gamma,180)==0
            rho_err_ellipse(theta_index) = abs(a/cosd(gamma));
        else
            rho_err_ellipse(theta_index) = a*b/sqrt(a^2*sind(gamma)^2+b^2*cosd(gamma)^2);
        end % if   
    end % for phi_index
    
    cart_err_ellipse = zeros(2,length(theta_in_deg));    
    [cart_err_ellipse(1,:),cart_err_ellipse(2,:)] = pol2cart(theta_in_deg./360*2*pi,rho_err_ellipse);
end % if

%% Calculations for length(S) == 1

if length(S) == 1
    z = max(norminv([(1-conf_interval)/2 conf_interval+(1-conf_interval)/2],0,1));
    rho_err_ellipse = z*sqrt(S(1,1));
    theta_0 = [];    
    cart_err_ellipse = [];
end % if

end % function