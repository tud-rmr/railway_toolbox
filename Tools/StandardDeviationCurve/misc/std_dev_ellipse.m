clear
close all
clc

rotate = @(phi) [cosd(phi) -sind(phi);sind(phi) cosd(phi)];

%%

sigma_x = 2;
sigma_y = 1;

p_x = sigma_x * randn(1e5,1);
p_y = sigma_y * randn(length(p_x),1);
p = [p_x';p_y'];

figure; 
% plot(p_x,p_y,'r.'); 
hold on;
for phi_i = 0:1:360    
    p_alpha = rotate(phi_i)*p;
    
    std_alpha = std(p_alpha(1,:));    
    
    std_alpha_x = cosd(phi_i)*std_alpha;
    std_alpha_y = sind(phi_i)*std_alpha;
    
    plot(std_alpha_x,std_alpha_y,'b.');
end % for phi_i
axis equal