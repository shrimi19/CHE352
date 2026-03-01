function gr=calcg(xp2, xp1);
global a zF
%keyboard
xp=[xp1 xp2 1-xp1-xp2];
yp=(xp.*a)/(sum(xp.*a));
gr=(xp(2)-yp(2))/(xp(1)-yp(1))-(zF(2)-xp(2))/(zF(1)-xp(1));