clear all
close all
clc

%%

phi_start = 10;
phi_end = 50;
R = -880;

t_start = [cosd(phi_start);sind(phi_start)];
t_end = [cosd(phi_end);sind(phi_end)];
L = calcClothoidLength(R,t_start,t_end)
l = 0:0.1:L;
[c,t,curv,radius] = clothoidTrackElement(l,L,0,R,phi_start);
phi_end_final = atan2d(t(2,end),t(1,end))

radii =radius;
curvature_external = -LineCurvature2D(c');

subplot(4,1,1);
plot(c(1,:),c(2,:),'-'); hold on;
axis equal
subplot(4,1,2);
plot(l,curv,'m.','MarkerSize',15); hold on;
plot(l,curvature_external,'b');
subplot(4,1,3);
plot(l,radii,'m.','MarkerSize',15); hold on;
% plot(l,1./curv,'b');
subplot(4,1,4);
plot(l,t);
axis equal

%%
% 
% function c = track(l)
% 
% R_1 = 400;
% phi_1 = -90;
% T_1 = [0;0];
% 
% R_2 = 400;
% phi_2 = -90;
% T_2 = constantArc(R_1*pi,R_1,phi_1,T_1);
% % T_2 = [0;0];
% 
% l_i = [0;abs(R_1*pi)];
% 
% c = zeros(2,length(l));
% for l_index = 1:length(l)
%     l_current = l(l_index);
%     if l_current < l_i(2)
%         c(:,l_index) = constantArc(-1*(l_current-l_i(1)),R_1,phi_1,T_1);
%     else
%         c(:,l_index) = constantArc(l_current-l_i(2),R_2,phi_2,T_2);
%     end % if
%     
% %     plot(c(1,l_index),c(2,l_index),'.','MarkerSize',20); hold on;
% end % for l_index
% 
% end % function track