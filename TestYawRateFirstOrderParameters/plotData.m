%testYawRate
%17/10/2019

close all;
clear;
clc;

addpath('functions');

%% Get Data
getData;

%% Plot Data
figure;
plot(time,yawRate,'b.-');
title('YawRate');
xlabel('Time [s]');
ylabel('[rad/s]');

figure;
plot(time,vx,'b.-');
title('Vx');
xlabel('Time [s]');
ylabel('[m/s]');

figure;
plot(time,deltaDesired,'b.-');
hold on;
plot(time,delta,'r.-');
title('Delta');
xlabel('Time [s]');
ylabel('[rad]');
legend('desiredDesired','delta','Location','southeast');

rmpath('functions');

