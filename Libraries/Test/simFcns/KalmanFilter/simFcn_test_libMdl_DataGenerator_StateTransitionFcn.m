function [x_k_hat,F_k] = simFcn_test_libMdl_DataGenerator_StateTransitionFcn(x_k,z,u_k,sample_time)

if abs(x_k(7)) > 5*eps
    [x_k_hat,F_k] = ... 
        ctra_model(x_k,sample_time);
else
    [x_k_hat,F_k] = ... 
        ca_model(x_k,sample_time);
end % if

end

function [x_k_hat,F_k] = ctra_model(x_k,sample_time)

% Init ____________________________________________________________________

T = sample_time;

x     = x_k(1);
y     = x_k(2);
d     = x_k(3);
v     = x_k(4);
a     = x_k(5);
theta = x_k(6);
w     = x_k(7);

% x_k_hat _________________________________________________________________

x_k_hat = x_k;

delta_x = 1/w^2*((v*w + a*w*T)*sin(theta+w*T)  ... 
          + a*cos(theta+w*T)                   ... 
          - v*w*sin(theta) - a*cos(theta));
delta_y = 1/w^2*((-v*w - a*w*T)*cos(theta+w*T) ... 
          + a*sin(theta+w*T)                   ... 
          + v*w*cos(theta) - a*sin(theta));
x_k_hat(1,1) = x + delta_x;
x_k_hat(2,1) = y + delta_y;
x_k_hat(3,1) = d + v*T + 1/2*a*T^2;
x_k_hat(4,1) = v + a*T;
x_k_hat(5,1) = a;
x_k_hat(6,1) = theta + w*T;
x_k_hat(7,1) = w;

% F_k(x_k) ________________________________________________________________

F_k = ...
    [ 1, 0, 0,  (sin(theta + T*w) - sin(theta))/w,  (cos(theta + T*w) - cos(theta) + T*w*sin(theta + T*w))/w^2, -(a*sin(theta + T*w) - a*sin(theta) - w*cos(theta + T*w)*(v + T*a) + v*w*cos(theta))/w^2, (2*a*cos(theta) - 2*a*cos(theta + T*w) + v*w*sin(theta) - v*w*sin(theta + T*w) + T*v*w^2*cos(theta + T*w) + T^2*a*w^2*cos(theta + T*w) - 2*T*a*w*sin(theta + T*w))/w^3; ... 
      0, 1, 0, -(cos(theta + T*w) - cos(theta))/w, -(sin(theta) - sin(theta + T*w) + T*w*cos(theta + T*w))/w^2,  (a*cos(theta + T*w) - a*cos(theta) + w*sin(theta + T*w)*(v + T*a) - v*w*sin(theta))/w^2, (2*a*sin(theta) - 2*a*sin(theta + T*w) - v*w*cos(theta) + v*w*cos(theta + T*w) + T*v*w^2*sin(theta + T*w) + T^2*a*w^2*sin(theta + T*w) + 2*T*a*w*cos(theta + T*w))/w^3; ... 
      0, 0, 1,                                  T,                                                       T^2/2,                                                                                        0,                                                                                                                                                                      0; ... 
      0, 0, 0,                                  1,                                                           T,                                                                                        0,                                                                                                                                                                      0; ... 
      0, 0, 0,                                  0,                                                           1,                                                                                        0,                                                                                                                                                                      0; ... 
      0, 0, 0,                                  0,                                                           0,                                                                                        1,                                                                                                                                                                      T; ... 
      0, 0, 0,                                  0,                                                           0,                                                                                        0,                                                                                                                                                                      1];
 



end

function [x_k_hat,F_k] = ca_model(x_k,sample_time)

% Init ____________________________________________________________________

T = sample_time;

x     = x_k(1);
y     = x_k(2);
d     = x_k(3);
v     = x_k(4);
a     = x_k(5);
theta = x_k(6);
w     = x_k(7);

% x_k_hat _________________________________________________________________

x_k_hat = x_k;

delta_x = 1/2*a*T^2*cos(theta) + v*T*cos(theta);
delta_y = 1/2*a*T^2*sin(theta) + v*T*sin(theta);

x_k_hat(1) = x + delta_x;
x_k_hat(2) = y + delta_y;
x_k_hat(3) = d + v*T + 1/2*a*T^2;
x_k_hat(4) = v + a*T;
x_k_hat(5) = a;
x_k_hat(6) = theta;
x_k_hat(7) = 0;

% F_k(x_k) ________________________________________________________________

F_k = ...
    [ 1, 0, 0, T*cos(theta), (T^2*cos(theta))/2, -(T*sin(theta)*(2*v + T*a))/2, 0; ... 
      0, 1, 0, T*sin(theta), (T^2*sin(theta))/2,  (T*cos(theta)*(2*v + T*a))/2, 0; ... 
      0, 0, 1,            T,              T^2/2,                             0, 0; ... 
      0, 0, 0,            1,                  T,                             0, 0; ... 
      0, 0, 0,            0,                  1,                             0, 0; ... 
      0, 0, 0,            0,                  0,                             1, 0; ... 
      0, 0, 0,            0,                  0,                             0, 0];
end

