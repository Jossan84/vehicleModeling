%testFirstOrderParameters
%25/10/2019

close all;
clear;
more off;
clc;

addpath('functions');

%% Get Data
getData;

%% Transfer Function for Linear Regression
% yawRate(k+1) = a*yawRate(k) + b*(vx(k)/L)*tan(delta(k));

% Delay
% tDelay = 80e-3;
tDelay = 0;
d = floor(tDelay/T);

% Estimate a,b
Y = yawRate(2+d:end);
X = [yawRate(1:end-1-d),vx(1:end-1-d)/L .* tan(deltaDesired(1:end-1-d))];
[theta] = normalEqn(X, Y);
J = costFunction(X, theta', Y);

a = theta(1);
b = theta(2);

%% Get Transfer Function
tfYawRateDelta = tf(b,[1 -a],T)
tfYawRateDeltaDelay = tf(b,conv([1 0 0 0],[1 -a]),T); %z-4;

%% Plot Results
figure;
step(tfYawRateDelta);

figure;
bode(tfYawRateDelta,'b.-');
grid on;

figure;
rlocus(tfYawRateDelta);
grid on;

% Compute transfer function
yawRateEstimate =  a*yawRate + b*(vx/L).*tan(delta);

figure;
plot(time,yawRate,'b.-');
hold on;
grid on;
plot(time,[yawRate(1);yawRateEstimate(1:end-1)],'r.-');
title('Yaw Rate');
xlabel('Time [s]');
ylabel('Yaw Rate [rad/s]');
legend('YawRate','YawRateEstimated','Location','southeast');

%%
rmpath('functions');

