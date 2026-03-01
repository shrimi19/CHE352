xopt = [0.9901 0.0291 189.9072];
% keep x2 x3 constant vary x1
for i = 1:95
    x1(i) = 0.9 + 0.001*i;
    j1(i) = TAC([x1(i) xopt(2) xopt(3)]);
end

figure(1)
grid on
plot(x1,j1);
xlabel('benzene purity in recycle stream');
ylabel('total cost operation');
title('total cost operation vs benzene purity in recycle stream')

