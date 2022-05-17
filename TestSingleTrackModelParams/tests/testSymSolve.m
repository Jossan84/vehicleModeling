% testSymSolve.m
% 27/03/2019

clear; close all; more off; clc;

if exist('OCTAVE_VERSION', 'builtin') ~= 0% OCTAVE
    pkg load symbolic;
else% MATLAB
    ;
end

% Set constant parameters
T = 40e-3;% [s]
n = 12000;% []
steeringRatio = 16.0;% []
m = 1500;% [kg]
I_z = 1000;% [N m s^2]
C_f = 20000;% [N/rad]
C_r = 30000;% [N/rad]
l = 5;% [m]
l_f = 0.4 * l;% [m]
l_r = 0.6 * l;% [m]

% Set space state system
A = [-(C_f + C_r) / m, (-C_f * l_f + C_r * l_r) / m;
    (-C_f * l_f + C_r * l_r) / I_z, -(C_f * l_f^2 + C_r * l_r^2) / I_z];
B = [C_f / m;
    C_f * l_f / I_z] / steeringRatio;
    
theta_reg = [zeros(2, 1), A, B];

% Solve parameters
syms C_f_ C_r_ l_f_ l_r_ m_ steeringRatio_ I_z_;
m_ = m;

eq1 = -(C_f_ + C_r_) == m_ * theta_reg(1, 2);
eq2 = -C_f_ * l_f_ + C_r_ * l_r_ == m_ * theta_reg(1, 3);
eq3 = C_f_ == m_ * steeringRatio_ * theta_reg(1, 4);
eq4 = -C_f_ * l_f_ + C_r_ * l_r_ == I_z_ * theta_reg(2, 2);
eq5 = -(C_f_ * l_f_^2 + C_r_ * l_r_^2) == I_z_ * theta_reg(2, 3);
eq6 = C_f_ * l_f_ == I_z_ * steeringRatio_ * theta_reg(2, 4);

eqs = [eq1, eq2, eq3, eq4, eq5, eq6];

S = solve(eqs);

