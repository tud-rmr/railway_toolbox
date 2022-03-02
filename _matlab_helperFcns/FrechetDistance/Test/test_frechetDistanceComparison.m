clear all
close all
clc

%curve 1
t1=0:1:50;
X1=(2*cos(t1/5)+3-t1.^2/200)/2;
Y1=2*sin(t1/5)+3;

%curve 2
t2=0:1:50;
X2=(2*cos(t2/4)+2-t2.^2/200)/2;
Y2=2*sin(t2/5)+3;

%curve 3
t3=0:1:50;
X3=(2*cos(t3/4)+2-t3.^2/200)/2;
Y3=2*sin(t3/4+2)+3;

%% Version by Tristan Ursell

res = 0.01;
f12_TUrsell=frechet(X1',Y1',X2',Y2',res);
f13_TUrsell=frechet(X1',Y1',X3',Y3',res);
f23_TUrsell=frechet(X2',Y2',X3',Y3',res);
f11_TUrsell=frechet(X1',Y1',X1',Y1',res);
f22_TUrsell=frechet(X2',Y2',X2',Y2',res);
f33_TUrsell=frechet(X3',Y3',X3',Y3',res);

% figure;
% subplot(2,1,1)
% hold on
% plot(X1,Y1,'r','linewidth',2)
% plot(X2,Y2,'g','linewidth',2)
% plot(X3,Y3,'b','linewidth',2)
% legend('curve 1','curve 2','curve 3','location','eastoutside');
% xlabel('X')
% ylabel('Y')
% axis equal tight
% box on
% title(['three space curves to compare'])
% legend
% 
% subplot(2,1,2)
% imagesc([[f11_TUrsell,f12_TUrsell,f13_TUrsell];[f12_TUrsell,f22_TUrsell,f23_TUrsell];[f13_TUrsell,f23_TUrsell,f33_TUrsell]])
% xlabel('curve')
% ylabel('curve')
% cb1=colorbar('peer',gca);
% set(get(cb1,'Ylabel'),'String','Frechet Distance')
% axis equal tight

%% Version by Zachary Danziger

P = [X1',Y1'];
Q = [X2',Y2'];

f12_ZDanziger=DiscreteFrechetDist([X1',Y1'],[X2',Y2']);
f13_ZDanziger=DiscreteFrechetDist([X1',Y1'],[X3',Y3']);
f23_ZDanziger=DiscreteFrechetDist([X2',Y2'],[X3',Y3']);
f11_ZDanziger=DiscreteFrechetDist([X1',Y1'],[X1',Y1']);
f22_ZDanziger=DiscreteFrechetDist([X2',Y2'],[X2',Y2']);
f33_ZDanziger=DiscreteFrechetDist([X3',Y3'],[X3',Y3']);

%% Output

output_table = table();
output_table.TUrsell = [f12_TUrsell;f13_TUrsell;f23_TUrsell;f11_TUrsell;f22_TUrsell;f33_TUrsell];
output_table.ZDanziger = [f12_ZDanziger;f13_ZDanziger;f23_ZDanziger;f11_ZDanziger;f22_ZDanziger;f33_ZDanziger];
output_table.Delta = abs(output_table.TUrsell-output_table.ZDanziger);

output_table



