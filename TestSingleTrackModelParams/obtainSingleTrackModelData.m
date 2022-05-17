% testSingleTrackModelParams.m
% 30/03/2019

addpath('functions');
addpath('plots');
addpath('scripts');
addpath('data');

clear; close all; more off; clc;

if exist('OCTAVE_VERSION', 'builtin') ~= 0% OCTAVE
    pkg load symbolic;
else% MATLAB
    ;
end

%% Get Data
getData

%% Linear regression to get parameter estimation
% y_reg = [dv_y_sensor + v_x_sensor .* yawRate_sensor, dyawRate_sensor];
% X_reg = [ones(n, 1), v_y_sensor ./ v_x_sensor, yawRate_sensor ./ v_x_sensor, delta_s];
% 
% theta_reg = normalEqn(X_reg, y_reg);
% J         = costFunction(X_reg, theta_reg, y_reg);

% %% Simulation whit the parameters obtained 
% % Initialization
% v_y_reg     = zeros(n + 1, 1); % [m/s]
% yawRate_reg = zeros(n + 1, 1); % [rad/s]
% 
% v_y_reg(1)     = (725 * pi / 13968)  * 0;
% yawRate_reg(1) = (25 * pi / 776) * 0;
% 
% X = [v_y_reg(1);
%     yawRate_reg(1)];
% 
% % Regenerate outputs
% A_reg = theta_reg(:, 2 : 3);
% B_reg = theta_reg(:, 4);
% for k = 1 : n
%     % Update A(k)
%     A_reg_k = A_reg * (1 / v_x(k)) + [0, -v_x(k); 0, 0];
%     %X = [v_y_sensor(k); yawRate_sensor(k)];
%     dX = A_reg_k * X + B_reg * delta_s(k);
%     X = X + T * dX;
%     v_y_reg(k + 1) = X(1);
%     yawRate_reg(k + 1) = X(2);
% end

%% Get Single Track Model Parameters
% getSingleTrackModelParameters;

%% Plots
% [ x_G, y_G, yaw_G ] = local2global( v_x, v_y, yawRate, 0, 0, 0, T);
% plotSingleTrackModel;
