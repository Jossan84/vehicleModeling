% squareFcnMin.m
% 26/03/2019

function y = squareFcnMin(x, x_min, a)
    
    %a = 1;
    b = - 2 * a * x_min;
    c = -(a * x_min^2 + b * x_min);
    y = a * x.^2 + b * x + c;
    
end