function [s,t] = straightLineInterpolation(q,q_0,l)
% [s,t] = straightLineInterpolation(q)
%

[m,~] = straightLineRegression(q,q_0);
phi = atand(m);

t = repmat([cosd(phi); sind(phi)],1,length(l));

s = zeros(2,length(l));
for l_index = 1:length(l)
    l_current = l(l_index);
    t_current = t(:,l_index);
    
    s(:,l_index) = l_current*t_current + q_0;
end % for l_index

end % end function

