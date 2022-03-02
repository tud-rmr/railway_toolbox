clear all
close all
clc

%%

R = 10;
l_1 = (0:0.01:1);
l_2 = (0:0.01:0.15*(2*pi*abs(R)));
l_3 = (0:0.01:1);
l_4 = (0:0.01:1);
l_5 = (0:0.01:1);
l_6 = (0:0.01:1);
l = [l_1 ... 
     l_2+l_1(end) ... 
     l_3+l_1(end)+l_2(end) ... 
     l_4+l_3(end)+l_1(end)+l_2(end) ... 
     l_5+l_4(end)+l_3(end)+l_1(end)+l_2(end) ... 
     l_6+l_5(end)+l_4(end)+l_3(end)+l_1(end)+l_2(end)];

[c_1,t_1,curv_1,radius_1] = clothoidTrackElement(l_1,l_1(end),0,R);
phi_1_end = atan2d(t_1(2,end),t_1(1,end));

[c_2,t_2,curv_2,radius_2] = constantArcTrackElement(l_2,R,phi_1_end,c_1(:,end));
phi_2_start = atan2d(t_2(2,1),t_2(1,1));
phi_2_end = atan2d(t_2(2,end),t_2(1,end));

[c_3,t_3,curv_3,radius_3] = clothoidTrackElement(l_3,l_3(end),R,-R,phi_2_end,c_2(:,end));
phi_3_start = atan2d(t_3(2,1),t_3(1,1));
phi_3_end = atan2d(t_3(2,end),t_3(1,end));

[c_4,t_4,curv_4,radius_4] = constantArcTrackElement(l_4,-R,phi_3_end,c_3(:,end));
phi_4_start = atan2d(t_4(2,1),t_4(1,1));
phi_4_end = atan2d(t_4(2,end),t_4(1,end));

[c_5,t_5,curv_5,radius_5] = clothoidTrackElement(l_5,l_5(end),-R,0,phi_4_end,c_4(:,end));
phi_5_start = atan2d(t_5(2,1),t_5(1,1));
phi_5_end = atan2d(t_5(2,end),t_5(1,end));

[c_6,t_6,curv_6,radius_6] = straightLineTrackElement(l_6,phi_5_end,c_5(:,end));

c = [c_1 c_2 c_3 c_4 c_5 c_6];
t = [t_1 t_2 t_3 t_4 t_5 t_6];
curv = [curv_1 curv_2 curv_3 curv_4 curv_5 curv_6];
radii =[radius_1 radius_2 radius_3 radius_4 radius_5 radius_6];
curvature_external = -LineCurvature2D(c');

subplot(4,1,1);
plot(c_1(1,:),c_1(2,:),'.'); hold on;
plot(c_2(1,:),c_2(2,:),'.');
plot(c_3(1,:),c_3(2,:),'.');
plot(c_4(1,:),c_4(2,:),'.');
plot(c_5(1,:),c_5(2,:),'.');
plot(c_6(1,:),c_6(2,:),'.');
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