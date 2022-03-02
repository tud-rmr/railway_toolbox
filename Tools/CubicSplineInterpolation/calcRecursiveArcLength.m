function l_i = calcRecursiveArcLength(q,numSteps)
% l_i = calcRecursiveArcLength(q,numSteps)
%
% In:
%   q           Vector   Oberservation points
%   numSteps    Scalar   Number of recursion steps
%
% Out:
%   l_i     Vector   Arc lengths
%
% See: 
%   C. Hasberg. „Simultane Lokalisierung und Kartierung spurgeführter 
%   Systeme“, P. 25ff.
%

%% Initialization and checks

q_x = q(1:ceil(length(q)/2));
q_y = q(length(q_x)+1:end);

%% Calculations

h_i_recursive = euclideanDistance(q_x,q_y);
l_i_recursive = [0; cumsum(h_i_recursive)];   
step = 1;
while step ~= numSteps
    
    integration_wrapper_fcn = @(T) integration_fcn(q,l_i_recursive,T);
    
    l_i_recursive_temp = l_i_recursive;
    for j = 2:length(l_i_recursive)
        l_i_recursive_temp(j) = l_i_recursive_temp(j-1) + integral(integration_wrapper_fcn,l_i_recursive(j-1),l_i_recursive(j));
    end % for j
    l_i_recursive = l_i_recursive_temp;
    
    step = step + 1;
    
end % for i

% Output __________________________________________________________________

l_i = l_i_recursive;

end % end function calcRecursiveArcLength

function norm_t = integration_fcn(q,l_i,T)
    [~,t] = cubicSpline(q,l_i,T);
    norm_t = arrayfun(@(arr1,arr2) norm([arr1,arr2]),t(1,:),t(2,:));
end % end function integration_fcn

