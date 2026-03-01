xopt = [0.9901 0.0291 189.9072];
% keep x2 x3 constant vary x1

for i = 1:99
   x2(i) = 0.003*i;
   x2f(i) = 1 - x2(i);
   j2(i) = TAC([xopt(1) x2(i) xopt(3)]);
end

figure(2)
grid on
scatter(x2f,j2);
xlabel('Diethyl-Benzene purity in the recycle stream');
ylabel('total cost operation');
title('total cost operation vs Diethyl-Benzene purity in the recycle stream');

