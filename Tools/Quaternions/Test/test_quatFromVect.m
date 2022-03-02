clear all
close all
clc

%%

u = [2;0;0];
v = [-1;0;0];

q_uv = quatFromVect(u,v);

u_new = transformVect(u,q_uv);

%% Plot

figure_name = ['Test Quaternion From Two Vectors'];
close(findobj('Type','figure','Name',figure_name));
figure('Name',figure_name); hold on; grid on;

clear h_plot    
h_plot = gobjects(0);  

h_plot(end+1) = plot3([0 u(1)],[0 u(2)],[0 u(3)],'k-','LineWidth',1.5,'MarkerSize',10,'DisplayName','u (original))');
h_plot(end+1) = plot3([0 v(1)],[0 v(2)],[0 v(3)],'b-','LineWidth',1.5,'MarkerSize',10,'DisplayName','v (original))');
h_plot(end+1) = plot3([0 u_new(1)],[0 u_new(2)],[0 u_new(3)],'r--','LineWidth',1.5,'MarkerSize',10,'DisplayName','u (new))');
legend(h_plot);
xlabel('x')
ylabel('y')
zlabel('z')