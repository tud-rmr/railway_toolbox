function [G,dG] = cubicSplineWeightFunction2D(q,l_i,l)
% [G,dG] = cubicSplineWeightFunction2D(q,l_i,l)
% 
% In:
%   q = supportive points
%   l_i = vector with arc length corresponding to q
%   l = (optional) arc length of interest
%
% Out:
%   G --> see page 40
%   dG --> see page 45
%
% See: 
%   C. Hasberg. „Simultane Lokalisierung und Kartierung spurgeführter 
%   Systeme“, P. 40 and P. 45
%

q_x = q(1:length(l_i));
q_y = q(length(l_i)+1:end);

[g_x,dg_x] = cubicSplineWeightFunction1D(q_x,l_i,l);
[g_y,dg_y] = cubicSplineWeightFunction1D(q_y,l_i,l);

G = [g_x,                               zeros(size(g_x,1),size(g_y,2)); ... 
     zeros(size(g_y,1),size(g_x,2)),    g_y];
 
dG = [dg_x,                             zeros(size(dg_x,1),size(dg_y,2)); ... 
     zeros(size(dg_y,1),size(g_x,2)),   dg_y];

end % end function