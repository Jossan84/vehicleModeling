% testRegression.m
% 25/03/2019

clear;
close all;
more off;
clc;

T = 40e-3;
m = 10;
theta = [0, 2, 3, 6; 0, 4, 1, 8];
n = size(theta, 2) - 1;
%X_reg = [ones(m, 1), randi(100, m, n) .* rand(m, n)];
X = zeros(m + 1, n + 1);
dX = zeros(m, size(theta, 1));
X(1, :) = [1, randi(100, 1, n) .* rand(1, n)];
for i = 1 : m
    dX(i, :) = X(i, :) * theta';
    X(i + 1, :) = X(i, :) + [0, T * dX(i, :), 0];
end
y = dX;
X(end, :) = [];

theta_sol = (pinv(X' * X) * X' * y)';
%theta_sol = (inv(X' * X) * X' * y)';


lambda = 0 : 0.01 : 10;
for i = 1 : length(lambda)
    theta_reg = (pinv(X' * X + lambda(i) * diag([0, ones(1, n)])) * X' * y)';
    J(i) = 1 / (2 * m) * sum(sum((X * theta_reg' - y)' * (X * theta_reg' - y)));
end

figure;
plot(lambda, J, 'b.-');
xlabel('lambda');
ylabel('J(theta)');