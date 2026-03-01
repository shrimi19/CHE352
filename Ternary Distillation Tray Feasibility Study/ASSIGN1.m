global a r s xB  xD
N = 50;
C = 3;
xD = zeros(1,C);
xB = zeros(1,C);
% xr = zeros(N,C);
% yr = zeros(N+1,C);

a = [3.25 1.9 1];
xF = [0.3 0.25 0.45];

r = 1.02;
xD(1,1) = 0.73;
xD(1,3) = 0.02;
xB(1,1) = 0.01;
xB(1,2) = 0.25;
xB(1,3) = 0.74;
xD(1,2) =0.25;
%xD(1,2)= 1 - xD(1,1) - xD(1,2);
DbyB = (xF(1,1)-xB(1,1))/(xD(1,1)-xF(1,1));
%xB(1,2) = (DbyB*(xD(1,2)-xF(1,2)))*(-1) +  xF(1,2);
%xB(1,3) = 1 - xB(1,2) - xB(1,1);
s = (r + 1)*DbyB;

[xr,yr] = topdown(N);
[xs,ys] = bottomup(N);

hold on
plot([0,1],[1,0])
plot(xr(:,1),xr(:,2),'r*');
plot(xs(:,1),xs(:,2),'g*');
title("for r = 1.02, xBA = 0.01 and xDC = 0.02 xDA = 0.73 ")


