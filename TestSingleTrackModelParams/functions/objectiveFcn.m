% objectiveFcn.m
% 29/03/2019

%% Objective function
% Outpus
%   - y    = Objective function to minimize Single Track Model
%   - grad = Gradient of the objective function
%
% Inputs
%   - x         = Variable    []
%   - theta_reg = Parameters of the Singel Track Model obtained from linear
%                 regression. []
%   - m         = mass of the car [kgm]
%
%
% Equations description:
%   - x(1) = C_f
%   - x(2) = C_r
%   - x(3) = l_f
%   - x(4) = l_r
%   - x(5) = steeringRatio
%   - x(6) = I_z
%
%   - f1 = -C_f - C_r -m * theta_reg(1, 2);
%   - f2 = -C_f*l_f + C_r*l_r - m * theta_reg(1, 3);
%   - f3 = C_f -m *  steeringRatio * theta_reg(1, 4);
%   - f4 = -C_f*l_f^2 + C_r*l_r^2 - I_z * theta_reg(2, 2);
%   - f5 = -C_f*l_f^2 - C_r*l_r^2 - I_z * theta_reg(2, 3);
%   - f6 = C_f*l_f - I_z * steeringRatio * theta_reg(2,4);

function [y, grad] = objectiveFcn(x, theta_reg, m)
    
    f1 = @(x)(-x(1) - x(2) - m * theta_reg(1, 2)); % Function
    df1 = @(x)([-1, -1, 0, 0, 0, 0]);              % Gradient
    
    f2 = @(x)(-x(1) * x(3) + x(2) * x(4) - m * theta_reg(1, 3));
    df2 = @(x)([-x(3), x(4), -x(1), x(2), 0, 0]);
    
    f3 = @(x)(x(1) - m * x(5) * theta_reg(1, 4));
    df3 = @(x)([1, 0, 0, 0, -m * theta_reg(1, 4), 0]);
    
    f4 = @(x)(-x(1) * x(3) + x(2) * x(4) - x(6) * theta_reg(2, 2));
    df4 = @(x)([-x(3), x(4), -x(1), x(2), 0, -theta_reg(2, 2)]);
    
    f5 = @(x)(-x(1) * x(3)^2 - x(2) * x(4)^2 - x(6) * theta_reg(2, 3));
    df5 = @(x)([-x(3)^2, -x(4)^2, -2 * x(1) * x(3), -2 * x(2) * x(4), 0, -theta_reg(2, 3)]);
    
    f6 = @(x)(x(1) * x(3) - x(6) * x(5) * theta_reg(2, 4));
    df6 = @(x)([x(3), 0, x(1), 0, -x(6) * theta_reg(2, 4), -x(5) * theta_reg(2, 4)]);
    
    f = f1(x)^2 + f2(x)^2 + f3(x)^2 + f4(x)^2 + f5(x)^2 + f6(x)^2; % Function
    df = 2 * f1(x) * df1(x) +...                                   % Gradient 
        2 * f2(x) * df2(x) +...
        2 * f3(x) * df3(x) +...
        2 * f4(x) * df4(x) +...
        2 * f5(x) * df5(x) +...
        2 * f6(x) * df6(x);
   
    y = f;
    grad = df;
    
end