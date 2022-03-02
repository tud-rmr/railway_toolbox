function [s,t] = cubicSpline(q,l_i,l)
% function [s,t] = cubicSpline(q,l_i,l)
%
% In:
%   q       Vector/Matrix   Oberservation points
%   l_i     Vector          Arc lengths, leave it empty [] if unknown
%   l       Scalar/Vector   Arc length of interest
%
% Out:
%   s       Vector/Matrix   Spline coordinates
%   t       Vector/Matrix   Spline direction
%
% See: 
%   C. Hasberg. „Simultane Lokalisierung und Kartierung spurgeführter 
%   Systeme“, S. 35ff.
%

%% Initialization and checks

q_x = q(1:ceil(length(q)/2));
q_y = q(length(q_x)+1:end);

%% Calculations

if isempty(l_i) 
    l_i = calcRecursiveArcLength(q,2);
end % if

s = zeros(2,length(l));
t = s;
for l_index = 1:length(l)
    l_current = l(l_index);     

    [G,dG] = cubicSplineWeightFunction2D(q,l_i,l_current);

    s(:,l_index) = G * q;
    t(:,l_index) = dG * q;
end % for l_index

end % end function





