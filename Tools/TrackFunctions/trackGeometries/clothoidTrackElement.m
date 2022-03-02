function [c_n,t_n,curv_n,radius_n] = clothoidTrackElement(l,L,R_start,R_end,rot_angle,trans_vector)
% function [c_n,t_n,curv_n,radius_n] = clothoidTrackElement(l,L,R_start,R_end,rot_angle,trans_vector)
%
% R:    positiv --> right turn in driving direction
%       negativ --> left turn in driving direction
% For definition see: Volker Matthews. Bahnbau (7. Auflage), S. 99

%% Initialization and checks

% Checks___________________________________________________________________

if L < 0
    error('''L'' has to be a positiv real value!');
end % if

if (R_start == 0) && (R_end == 0)
    error('''R_start'' and ''R_end'' are equal zero!');
end % if

if nargin == 4
    rot_angle = 0;
    trans_vector = [0;0];
elseif nargin == 5
    trans_vector = [0;0];
end % end if

% Initialization___________________________________________________________

rotation_matrix = @(phi) [cos(phi/360*2*pi) -sin(phi/360*2*pi);sin(phi/360*2*pi) cos(phi/360*2*pi)];

%% Calculations

% Create clothoid__________________________________________________________

if L > 0
    if (R_start == 0) && (R_end ~= 0) % normal clothoid
        [c_n,t_n,curv_n,radius_n] = clothoid(l,L,R_end);
    elseif (R_start ~= 0) && (R_end == 0) % reverse clothoid    
        [c_n,t_n,curv_n,radius_n] = reverseClothoid(l,L,R_start);         
    elseif ((R_start ~= 0) && (R_end ~= 0)) && (sign(R_start) ~= sign(R_end)) % Clothoid with start and end radius (turning)   
        [c_n,t_n,curv_n,radius_n] = turningClothoid(l,L,R_start,R_end);    
    elseif ((R_start ~= 0) && (R_end ~= 0)) && (sign(R_start) == sign(R_end)) % Clothoid with start and end radius  (transitioning)  
        [c_n,t_n,curv_n,radius_n] = transitionClothoid(l,L,R_start,R_end);     
    end % if
elseif L == 0
    c_n = [0;0];
    t_n = [1;0];
    curv_n = [1/R_start];
    radius_n = R_start;
    
    warning('clothoidTrackElement: Track-element length is 0! End-curvautre can''t be reached!'); 
end % if

% Adjust orientation_______________________________________________________

c_n = rotation_matrix(rot_angle)*c_n + trans_vector;
t_n = rotation_matrix(rot_angle)*t_n;
    
end % end function clothoidTrackElement

% function [s_n,t_n,curv_n,radius_n] = clothoid(l,L,R)
% % see: https://www.frassek.org/2d-mathe/klothoide-cornu-spirale/
% 
% clothoid_integral = @(t) [cos(pi*t.^2/2);sin(pi*t.^2/2)];
% 
% s_n = nan(2,length(l));
% t_n = s_n;
% curv_n = nan(1,length(l));
% radius_n = curv_n;
% 
% direction_flag = [1;-sign(R)];
% 
% 
% 
% A = sqrt(abs(L)*abs(R));
% T = L^2/(2*A^2);
% 
% s_n(1,:) = l .* ( 1 ... 
%                   -  T^2 /(factorial(2) * 5) ...
%                   +  T^4 /(factorial(4) * 9) ...
%                   -  T^6 /(factorial(6) *13) ...
%                   +  T^8 /(factorial(8) *17) ...
%                   -  T^10/(factorial(10)*21) ...
%                   +  T^12/(factorial(12)*25) ...
%                   -  T^14/(factorial(14)*29) ...
%                   +  T^16/(factorial(16)*33) ...
%                 );
% s_n(2,:) = l .* ( T/3 ... 
%                   -  T^3 /(factorial(3) * 7) ...
%                   +  T^5 /(factorial(5) *11) ...
%                   -  T^7 /(factorial(7) *15) ...
%                   +  T^9 /(factorial(9) *19) ...
%                   -  T^11/(factorial(11)*23) ...
%                   +  T^13/(factorial(13)*27) ...
%                   -  T^15/(factorial(15)*31) ...
%                   +  T^17/(factorial(17)*35) ...
%                 );
% s_n = direction_flag .* s_n;
% t_n = direction_flag .* clothoid_integral(l./(A*sqrt(pi)));
%             
% curv_n = l.*(1/R)/L;
% radius_n = L*R./l;
% radius_n(abs(radius_n)==inf) = 0;
%     
% end % function clothoid

function [s_n,t_n,curv_n,radius_n] = clothoid(l,L,R)

A = sqrt(abs(L)*abs(R));
direction_flag = [1;-sign(R)];

integration_fcn = @(T) [cos(pi*T^2/2);sin(pi*T^2/2)];
clothoid_fcn = @(l) A*sqrt(pi)*integral(integration_fcn,0,l/(A*sqrt(pi)),'ArrayValued',1);

s_n = zeros(2,length(l));
t_n = s_n;
curv_n = zeros(1,length(l));
radius_n = zeros(1,length(l));

for l_index = 1:length(l)
    
    s_n(:,l_index) = direction_flag .* clothoid_fcn(l(l_index));
    t_n(:,l_index) = direction_flag .* integration_fcn(l(l_index)/(A*sqrt(pi)));
    curv_n(1,l_index) = l(l_index)*(1/R)/L;
    if l(l_index) ~= 0
        radius_n(1,l_index) = L*R/l(l_index);
    else
        radius_n(1,l_index) = 0;
    end % if

end % for l_index
    
end % function clothoid

function [s_n,t_n,curv_n,radius_n] = reverseClothoid(l,L,R)

if min(l) < 0
    error('Reverse Clothoid not defined for ''l < 0 ''!');
end % end if

rotation_matrix = @(phi) [cos(phi/360*2*pi) -sin(phi/360*2*pi);sin(phi/360*2*pi) cos(phi/360*2*pi)];

% Correction parameters
l = -1*(l - L);
[c_n_offset,t_n_offset,~] = clothoid(L,L,R);
phi_correct = atan2d(t_n_offset(2,1),t_n_offset(1,1));

% Create reverse clothoid    
[s_n,t_n,curv_n,radius_n] = clothoid(l,L,R);

% Move reverse clothoid to origin and fix turn direction
s_n = +1 * [-1;1] .* (s_n - c_n_offset);
t_n = -1 * [-1;1] .* t_n; 
curv_n = curv_n;
radius_n = radius_n;

% Make sure starting direction is horizontal    
s_n = rotation_matrix(phi_correct)*s_n;
t_n = rotation_matrix(phi_correct)*t_n;
    
end % end function reverseClothoid

function [s_n,t_n,curv_n,radius_n] = transitionClothoid(l,L,R_start,R_end)

rotation_matrix = @(phi) [cos(phi/360*2*pi) -sin(phi/360*2*pi);sin(phi/360*2*pi) cos(phi/360*2*pi)];

c_start = 1/R_start;
c_end = 1/R_end;
delta_c = c_end-c_start;

if abs(c_end) > abs(c_start)
    L_temp = c_end/delta_c*L;
    l = l + c_start/delta_c*L;    
    [s_n,t_n,curv_n,radius_n] = clothoid(l,L_temp,R_end);
    
    l_0 = 0 + c_start/delta_c*L;
    [s_n_0,t_n_0,~,~] = clothoid(l_0,L_temp,R_end);
    
    phi_correct = -atan2d(t_n_0(2,1),t_n_0(1,1));
    s_n = rotation_matrix(phi_correct)*(s_n-s_n_0);
    t_n = rotation_matrix(phi_correct)*t_n;
else
    delta_c = delta_c * -1;
    L_temp = c_start/delta_c*L;
    [s_n,t_n,curv_n,radius_n] = reverseClothoid(l,L_temp,R_start);
end % if
    
end % function transitionClothoid

function [s_n,t_n,curv_n,radius_n] = turningClothoid(l,L,R_start,R_end)
    
[c_n_offset,t_offset,~] = clothoidTrackElement(L/2,L/2,R_start,0);
phi_correct = atan2d(t_offset(2,end),t_offset(1,end));     

% s_n = zeros(2,length(l));
% t_n = s_n;
% curv_n = zeros(1,length(l));
% radius_n = zeros(1,length(l));
% for l_index = 1:length(l)
%     if l(l_index) < L/2
%         [s_n(:,l_index),t_n(:,l_index),curv_n(1,l_index),radius_n(1,l_index)] = clothoidTrackElement(l(l_index)-0,L/2,R_start,0);
%     else
%         [s_n(:,l_index),t_n(:,l_index),curv_n(1,l_index),radius_n(1,l_index)] = clothoidTrackElement(l(l_index)-L/2,L/2,0,R_end,phi_correct,c_n_offset);
%     end % if
% end % for l_index

s_n = zeros(2,length(l));
t_n = s_n;
curv_n = zeros(1,length(l));
radius_n = zeros(1,length(l));
l_first_half_selector = (l < L/2);

[s_n(:,l_first_half_selector),t_n(:,l_first_half_selector),curv_n(1,l_first_half_selector),radius_n(1,l_first_half_selector)] = clothoidTrackElement(l(l_first_half_selector)-0,L/2,R_start,0);
[s_n(:,~l_first_half_selector),t_n(:,~l_first_half_selector),curv_n(1,~l_first_half_selector),radius_n(1,~l_first_half_selector)] = clothoidTrackElement(l(~l_first_half_selector)-L/2,L/2,0,R_end,phi_correct,c_n_offset);

    
end % function turningClothoid

