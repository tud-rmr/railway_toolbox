function [m,n] = straightLineRegression(q,q_0)
% [m,n] = straightLineRegression(q,q_0)
%

q_x = q(1:length(q)/2);
q_y = q(length(q)/2+1:end);

if nargin == 1
    w = [q_x ones(length(q_x),1)] \ q_y;
    
    m = w(1);
    n = w(2);
else
    m = (q_x-q_0(1))\(q_y-q_0(2));
    n = (q_0(2)-m*q_0(1));
end % if

end % end function
