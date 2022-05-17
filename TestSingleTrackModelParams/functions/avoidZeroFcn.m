% avoidZeroFcn.m
% 26/03/2019

function y = avoidZeroFcn(x, x_min)
    y = zeros(size(x));
    
    y_0 = 1e12;
    
    index = x < x_min;
    y(index) = y_0 * (1 - x(index) ./ x_min(index));
end