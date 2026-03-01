function [xs,ys] = bottomup(N)
global a s xB
ys = zeros(N,length(xB));
xs = zeros(N,length(xB));

xs(1,:)=xB;
for i = 1:N
    ys(i,:) = xs(i,:).*a/(sum(xs(i,:).*a));
    xs(i+1,:) = s/(s+1)*ys(i,:)+ xB/(s+1);
end
end
