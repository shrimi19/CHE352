F = 100;
P_column = 1.1*750;
global a
x1 = linspace(0,1,100);

for i = 1:100
fun = @(T) 1.1*750 -x1(i)*10^(6.905 - (1211.03/(220.7 + T))) - (1 - x1(i))*10^(6.99 - (1453.43/(215.31 + T)));
T0 = 80;
T(i) = fzero(fun,T0);
p_benzene(i) = 10^(6.905 - (1211.03/(220.7 + T(i))));
p_xylene(i) = 10^(6.99 - (1453.43/(215.31 + T(i))));
y1(i) = (x1(i)*p_benzene(i))/P_column;
end

x2 = linspace(0,1,100);
for i = 1:100
fun = @(T) 1.1*750 -x1(i)*10^(6.954 - (1344.8/(219.48 + T))) - (1 - x1(i))*10^(6.99 - (1453.43/(215.31 + T)));
T0 = 80;
T(i) = fzero(fun,T0);
p_toluene(i) = 10^(6.954 - (1344.8/(219.48 + T(i))));
p_xylene(i) = 10^(6.99 - (1453.43/(215.31 + T(i))));
y2(i) = (x1(i)*p_toluene(i))/P_column;
end

func=@(alpha,x1)(alpha.*x1./(alpha.*x1+(1-x1))); %non-linear least square curve fit 
alpha_req1=lsqcurvefit(func,1,x1,y1);
func=@(alpha,x2)(alpha.*x2./(alpha.*x2+(1-x2)));%non-linear least square curve fit
alpha_req2=lsqcurvefit(func,1,x2,y2);
alpha_req3=1;

%plot(x1,T)
%hold on
%plot(y1,T);

%%

a = [alpha_req1 alpha_req2 1]';
z = [1 1 1]'/3;

xd1 = 0.99;
xb1 = 0.01;
xd2 = linspace(0.0054,0.01,100);
xd3 = 1 - xd1 - xd2;

for i = 1:100
xD(:,i) = [xd1 xd2(i) xd3(i)]';
dbyb = (xb1 - z(1))/(z(1) - xd1);
xb2(i) = dbyb*(z(2) - xd2(i)) + z(2);
xb3(i) = dbyb*(z(3) - xd3(i)) + z(3);
xB(:,i) = [xb1 xb2(i) xb3(i)]';
r0 = 2;
s0 = dbyb*(r0+1);
rmin=r0; smin=s0;
flag=1; dr=0.01; count=0;
xpr=calcrectifyingpinch(xD(:,i),rmin,[0 1 0]'); %rectifying saddle
xps=calcstrippingpinch(xB(:,i),rmin,[1 0 0]'); %stripping node
e1=z(1:2)-xpr(1:2);
e2=xps(1:2)-xpr(1:2); 
area=det([e1 e2]);
xpr=[0 1 0]';
xps=[1 0 0]';
b=(0.95:-0.01:0.01)';
N=length(b);
area=zeros(N,1);
r=area;
for j=1:N
    r=b(j)/(1-b(j));
    s=(r+1)*dbyb;
    xpr=calcrectifyingpinch(xD(:,i),r,xpr); %rectifying saddle
    xps=calcstrippingpinch(xB(:,i),s,xps); %stripping node
    e1=z(1:2)-xpr(1:2);
    e2=xps(1:2)-xpr(1:2);
    area(j)=det([e1 e2]);
end
% Direct interpolation to find b where area = 0
if any(area > 0) && any(area < 0)  % Ensure a sign change exists
        b_zero(i) = interp1(area, b, 0, 'linear', 'extrap');
else
        b_zero(i) = NaN; % No zero-crossing found
end
figure(1)
plot(b,area);

rmin = b_zero./(1 - b_zero);

r = 1.25*rmin;
end

%%
function fs=calcfs(xp,s,xB)
%fs=calcfs(xp,s,xB);
global a

yp=a.*xp./(sum(a.*xp));
fs=xp(1:2)-s/(s+1)*yp(1:2)-1/(s+1)*xB(1:2);
end

function f=calcf(xp,r,xD)
%f=calcf(x,r,xD);
global a

yp=a.*xp./(sum(a.*xp));
f=yp(1:2)-r/(r+1)*xp(1:2)-1/(r+1)*xD(1:2);
end

function J=calcJ(xp,r,xD)
%J=calcJ(x,r,xD)
C=length(xD);
dfdx=zeros(C-1,C-1);
J=zeros(C-1,C-1);
f0=calcf(xp,r,xD);
dx=1e-6;
%keyboard
for i=1:C-1
    idx=zeros(C,1);
    idx(i)=1;
    xplus=xp+dx*idx;
    xplus(3)=1-xplus(1)-xplus(2);
    dfdx(:,i)=(calcf(xplus,r,xD)-f0)/dx;
end
J=dfdx;
end

function Js=calcJs(xp,s,xB)
%J=calcJ(x,r,xD)
C=length(xB);
dfdx=zeros(C-1,C-1);
Js=zeros(C-1,C-1);
f0=calcfs(xp,s,xB);
dx=1e-6;
%keyboard
for i=1:C-1
    idx=zeros(C,1);
    idx(i)=1;
    xplus=xp+dx*idx;
    xplus(3)=1-xplus(1)-xplus(2);
    dfdx(:,i)=(calcfs(xplus,s,xB)-f0)/dx;
end
Js=dfdx;
end

function xp=calcstrippingpinch(xB,s,xp0);
%xp=calcstrippingpinch(xB,s,xp0)
flag=1; count=0;
alpha=0.2;
xp=xp0;
while flag
    fs=calcfs(xp,s,xB);
    if sum(abs(fs))<1e-10
        flag=0;
    else
        Js=calcJs(xp,s,xB);
        dx=-alpha*inv(Js)*fs;
        xp(1:2)=xp(1:2)+dx;
        xp(3)=1-xp(1)-xp(2);
        count=count+1;
        %disp([count xp'])
    end
    if count>200
        flag=0;
        disp('Did not converge in 200 iterations')
    end
end
end

function xp=calcrectifyingpinch(xD,r,xp0)
%[xp,yp]=calcrectifyingpinch(xD,r,xp);
global a
flag=1; count=0;
alpha=0.2;
xp=xp0;
while flag
    f=calcf(xp,r,xD);
    if sum(abs(f))<1e-10
        flag=0;
    else
        J=calcJ(xp,r,xD);
        dx=-alpha*inv(J)*f;
        xp(1:2)=xp(1:2)+dx;
        xp(3)=1-xp(1)-xp(2);
        count=count+1;
        %disp([count xp'])
    end
    if count>200
        flag=0;
        disp('Did not converge in 200 iterations')
    end
end
end


%%
%{
%calculate number of plates
xd1 = zeros(3, 100);
xb1 = zeros(3, 100);
rcheck = zeros(1, 100);
DbyB1 = zeros(1, 100);
scheck = zeros(1, 100);
platenum = zeros(1, 100);
global a z
for i = 1:100
xd1(:,i) = xD(:,i);
xb1(:,i) = xB(:,i);
rcheck(i) = r(i);
DbyB1(i) = (xb1(1,i) - z(1)) / (z(1) - xd1(1,i));
scheck(i) = (rcheck(i)+1) * DbyB1(i);
[xr, yr] = topdown(N, xd1(:,i), a, rcheck(i), scheck(i));
[xs, ys] = bottomup(N, xb1(:,i), a, rcheck(i), scheck(i));
platenum(i) = calculate_plates(xr,yr,xs,ys);
end

function num_plates = calculate_plates(xr, yr, xs, ys)
    % Find the intersection of rectifying and stripping sections
    min_dist = inf;
    intersection_idx = -1;
    for i = 1:size(xr, 2)
        for j = 1:size(xs, 2)
             dist = norm(xr(:,i) - xs(:,j)) + norm(yr(:,i) - ys(:,j)); 
            if dist < min_dist
                min_dist = dist;
                intersection_idx = i;
            end
        end
    end
    if intersection_idx == -1
        error('No intersection found between rectifying and stripping sections');
    end
      num_plates = ceil(intersection_idx + intersection_idx);
end

function [xr, yr] = topdown(N, xd, a, r, s)
    yr = zeros(3,N+1);
    xr = zeros(3,N+1);
    yr(:,1) = xd;  % Convert column to row
    for i = 1:N
        xr(:,i) = (yr(:,i) ./ a) ./ sum(yr(:,i) ./ a);  % Ensure element-wise division
        yr(:,i+1) = r/(r+1) * xr(:,i) + (xd/(r+1));  % Transpose xD/(r+1) to match sizes
    end
end
function [xs, ys] = bottomup(N, xb, a, r, s)
    ys = zeros(3,N);
    xs = zeros(3,N);
    xs(:,1) = xb;  % Convert column to row
    for i = 1:N
        ys(:,i) = (xs(:,i) .* a) ./ sum(xs(:,i) .* a);  % Ensure correct element-wise multiplication
        xs(:,i+1) = s/(s+1) * ys(:,i)+(xb/(s+1));
    end
end
%}
%%
%calculate graph for given xd and r sloppy limit.
clc
N = 100;
xd = [0.99;0.00897777777777778;0.00102222222222223];  % Column vector
xb = [0.0100000000000000;0.493041398759165;0.496958601240835];  % Column vector
a = [5.0781; 2.1234; 1];  % Column vector
z = [0.333333333333333; 0.333333333333333; 0.333333333333333];  % Column vector
r_min = 1.55082827947476;
r = r_min*1.05;
DbyB = (xb(1) - z(1)) / (z(1) - xd(1));
s = (r+1) * DbyB;

figure(2)
[xr, yr] = topdown(N, xd, a, r, s);
plot(xr(:,1), xr(:,2), '*')
hold on
[xs, ys] = bottomup(N, xb, a, r, s);
plot(xs(:,1), xs(:,2), '*')
hold on
plot([1, 0], [0, 1])
%hold on
%plot([xd(1), xd(2)], [xb(1), xb(2)])
title("Plot of r_{min}")

function [xr, yr] = topdown(N, xd, a, r, s)
    yr = zeros(N+1, length(xd));
    xr = zeros(N+1, length(xd));
    yr(1,:) = xd.';  % Convert column to row

    for i = 1:N
        xr(i,:) = (yr(i,:) ./ a.') / sum(yr(i,:) ./ a.');  % Ensure element-wise division
        yr(i+1,:) = r/(r+1) * xr(i,:) + (xd.'/(r+1));  % Transpose xD/(r+1) to match sizes
    end
end

function [xs, ys] = bottomup(N, xb, a, r, s)
    ys = zeros(N, length(xb));
    xs = zeros(N, length(xb));
    xs(1,:) = xb.';  % Convert column to row

    for i = 1:N
        ys(i,:) = (xs(i,:) .* a.') / sum(xs(i,:) .* a.');  % Ensure correct element-wise multiplication
        xs(i+1,:) = s/(s+1) * ys(i,:)+(xb.'/(s+1));
    end
end


