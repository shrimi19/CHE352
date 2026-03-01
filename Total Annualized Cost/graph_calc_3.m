xopt = [0.9901 0.0291 189.9072];
% keep x2 x3 constant vary x1

for i = 1:99
    x3(i) = 139 + i;
    j3(i) = TAC([xopt(1) xopt(2) x3(i)]);
   % x3(i) = 139 + i;
    %j3(i) = 1612045;
  
end

figure(3)
grid on
scatter(x3,j3);
xlabel('Total Benzene fow rate into the reactor');
ylabel('total cost operation');
title('total cost operation vs Total Benzene fow rate into the reactor');