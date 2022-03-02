clear all
close all
clc

%%

l1 = 0:1:10;
g1 = @(l) 1.*l+2;
l2 = 0:1:15;
g2 = @(l) 1.5.*l+2;

y1 = g1(l1);
y2 = g2(l2);

P = [l1',y1'];
Q = [l2',y2'];

[cm,cSq] = DiscreteFrechetDist(P,Q)
cm_f = frechet(P(:,1),P(:,2),Q(:,1),Q(:,2),0.003)

%%

% plot result
figure
plot(Q(:,1),Q(:,2),'o-r','linewidth',3,'markerfacecolor','r')
hold on
plot(P(:,1),P(:,2),'o-b','linewidth',3,'markerfacecolor','b')
title(['Discrete Frechet Distance of curves P and Q: ' num2str(cm)])
legend('Q','P','location','best')
line([2 cm+2],[0.5 0.5],'color','m','linewidth',2)
text(2,0.4,'dFD length')
for i=1:length(cSq)
  line([P(cSq(i,1),1) Q(cSq(i,2),1)],...
       [P(cSq(i,1),2) Q(cSq(i,2),2)],...
       'color',[0 0 0]+(i/length(cSq)/1.35));
end
axis equal