function [p,P] = calcCubicSplineCoeff(q,l_i,l)
% [p,P] = calcCubicSplineCoeff(q,l_i,l)
%
% In:
%   q = supportive points
%   l_i = vector with arc length corresponding to q
%   l = (optional) arc length of interest
%
% Out:
%   p = [a,b,c,d]
%   P = {A,B,C,D}
%
% See: 
%   C. Hasberg. „Simultane Lokalisierung und Kartierung spurgeführter 
%   Systeme“, S. 37ff.
%

%% Initialization and checks

% Error handling___________________________________________________________

if size(q,1) < 3
    error('Not enough data points in q. You have to pass at least 3 points!');
end % if

if size(q,1) ~= length(l_i)
    error('Dimension mismatch q <-> l_i');
end % if

% Initialization __________________________________________________________

h_i = diff(l_i);

M = zeros(length(l_i),length(l_i));
L = M;

A1 = zeros(length(h_i),length(l_i));
B1 = A1;
B2 = A1;

%% Calculations

% M
M(1,1:2) = [1 -1];
M(end,[end-1:end]) = [1 -1];
for m_i = 1:length(l_i)-2
    M(m_i+1,m_i:m_i+2) = [h_i(m_i), 2*(h_i(m_i)+h_i(m_i+1)), h_i(m_i+1)];
end % for m_i

% L
for l_index = 1:length(l_i)-2
    L(l_index+1,l_index:l_index+2) = ... 
        [6/h_i(l_index), (-6/h_i(l_index)-6/h_i(l_index+1)), 6/h_i(l_index+1)];
end % for m_i

% A1
A1(1:length(h_i),1:length(h_i)) = eye(length(h_i));

% B1
for b_i = 1:length(h_i)
    B1(b_i,[b_i:b_i+1]) = [-1/h_i(b_i), 1/h_i(b_i)];
end % for m_i

% B2
for b_i = 1:length(h_i)
    B2(b_i,[b_i:b_i+1]) = [-2*h_i(b_i)/6, -h_i(b_i)/6];
end % for m_i

% C1
C1 = A1*0.5;

% D1
D1 = B1/6;

% Calculate matrices A, B, C, D ___________________________________________

M_temp = (M^-1)*L;

A = A1;
B = B1 + B2 * M_temp;
C = C1 * M_temp;
D = D1 * M_temp;

% Output __________________________________________________________________

P = {A,B,C,D};
p = [A*q,B*q,C*q,D*q];

if nargin == 3
    k = calcMaskVector(l_i,l);
    p = k'*p;
end % if

end % end function

