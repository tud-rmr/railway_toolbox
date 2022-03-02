function [g,dg] = cubicSplineWeightFunction1D(q,l_i,l)
% [g,dg] = cubicSplineWeightFunction1D(q,l_i,l)
%
% In:
%   q = supportive points
%   l_i = vector with arc length corresponding to q
%   l = (optional) arc length of interest
%
% Out:
%   g --> see page 38
%   dg --> see page 45
%
% See: 
%   C. Hasberg. „Simultane Lokalisierung und Kartierung spurgeführter 
%   Systeme“, S. 38 and S. 45
%

[~,P] = calcCubicSplineCoeff(q,l_i);
A = P{1};
B = P{2};
C = P{3};
D = P{4};

k = calcMaskVector(l_i,l);
l_i_current = l_i(logical(k));

g = k'*(A + B*(l-l_i_current) + C*((l-l_i_current)^2) + D*((l-l_i_current)^3));
dg = k'*(B + 2*C*(l-l_i_current) + 3*D*((l-l_i_current)^2));

end % end function

