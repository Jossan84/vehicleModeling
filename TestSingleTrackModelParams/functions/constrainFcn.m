% constrainFcn.m
% 26/03/2019

function y = constrainFcn(x)
    y = zeros(1, 7);
%    if any(x <= 0)
%        y = 1e6;
%    end
%    y = exp(-(sum(x)));
    
    %[C_f_, C_r_, l_f_, l_r_, m_, steeringRatio_, I_z_]
    factor = [0, 0, 0, 0, 0.01, 0.3, 0];
    x_min = [10, 10, 0.5, 0.5, 500, 10, 500];
    
    %y(5) = squareFcnMin(x(5), x_min(5), 0.1);
    %y(5) = cosh(factor(5) * (x(5) - x_min(5))) - 1;
        
    %y(6) = cosh(factor(6) * (x(6) - x_min(6))) - 1;
    
    %y = cosh(1e-4 * (x - 10000)) - 1;
    y = avoidZeroFcn(x, x_min);
    
    y = sum(y);
    
end