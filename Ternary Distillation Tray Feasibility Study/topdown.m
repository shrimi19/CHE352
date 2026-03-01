function [xr,yr] = topdown(N)
global a xD r
yr = zeros(N+1,length(xD));
xr = zeros(N,length(xD));

yr(1,:) = xD;
for i = 1:N
     xr(i,:) = yr(i,:)./a/(sum(yr(i,:)./a));
     yr(i+1,:) = r/(r+1)*xr(i,:)+xD/(r+1);
end
end
