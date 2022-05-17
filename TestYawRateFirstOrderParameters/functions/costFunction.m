% costFunction.m
% 25/03/2019

function J = costFunction(X, theta, y)
    
    m = size(X, 1);
    J = 1 / (2 * m) * sum(sum((X * theta' - y)' * (X * theta' - y)));

end