function k = calcMaskVector(l_i,l)
% k = calcMaskVector(l_i,l)
%
% In:
%   l_i = vector with arc length corresponding to the supportive points
%   l = arc length of interest
%
% Out:
%   k = mask vector with dimenstion (length(l_i)-1) x 1
%
% See: 
%   C. Hasberg. „Simultane Lokalisierung und Kartierung spurgeführter 
%   Systeme“, S. 37
%

if l < 0
    l = 0;
end % if

k = zeros(length(l_i)-1,1);
k_index = find(l >= l_i(1:end-1),1,'last');
k(k_index) = 1;

end % end function

