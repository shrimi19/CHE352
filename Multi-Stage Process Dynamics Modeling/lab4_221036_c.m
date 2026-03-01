xf = [0.33 0.33 0.34];
alpha = [4 2 1];
xa =  linspace(0.331,0.99,100);
xb = zeros(size(xa));
tol = 1e-8;
options = optimset('TolX',tol);
for i = 1:100
    fun = @(x) splitx(alpha,xf,x,xa(i));
    x0 = 0.005;
    xb(i) = fzero(fun,x0,options);
end
xg = linspace(0,0.5,100);
yg = (xf(2)/(xf(1))).*xg;
xh = linspace(0,1,100);
yh = (xf(2)/(xf(1) - 1))*(xh - 1);
plot([0 1], [1 0])
hold on
plot(xa,xb,'LineWidth',2)
hold on
plot(xg,yg)
hold on
plot(xh,yh)
title('ternary diagram for(c)')
xlabel('xa')
ylabel('xb')


function ans = splitx(alpha,xf,x2,x1)
y1 = alpha(1)*x1/(alpha(1)*x1 + alpha(2)*x2 + (1-x1-x2)*alpha(3));
y2 = alpha(2)*x2/(alpha(1)*x1 + alpha(2)*x2 + (1-x1-x2)*alpha(3));
ans = (y2 - x2)/(y1 - x1) - (xf(2) - x2)/(xf(1) - x1);
end