%getSteeringRatioSimulation
%09/12/2019

close all;
clear;
clc;

%% Get Data
addpath('data/logsCarSim_Mercedes_Class_B');
load('logCarSim500_10.mat');

%% Car Parameters
L = 2.910;
a = 1.015;
b = L - a; 
L_ = L; % Distance from measurement axis (center of front axe) to center of rear axe.

x = simout.x.Data;
y = simout.y.Data;

[m n] = size(simout.SteeringWheel.Data);
angle_test_index = round(m/2);

steering_wheel_angle = deg2rad(simout.SteeringWheel.Data(angle_test_index));

%% Turning Radius & Steering Ratio
[m n] = size(x);

for i=1:m-1
    p1 = [x(1) y(1)];
    p2 = [x(i) y(i)];
    d(i) = norm(p1 - p2);   
end
    
diameter = max(abs(d));

% Measured in the middle of the rear axe
% R = diameter/2;
% 
% wheel_angle = atan(L/R)
% Steering_Ratio = steering_wheel_angle/wheel_angle

% Measured in other point
R = diameter/2;
R = sqrt((R^2)-(L_^2));

wheel_angle = atan(L/R);
Steering_Ratio = steering_wheel_angle/wheel_angle;

%% Display Data
fprintf('Steering Wheel Angle [rad] = %d\n',steering_wheel_angle);
fprintf('Wheel Angle [rad]          = %d\n',wheel_angle);
fprintf('Steering Ratio []          = %d\n',Steering_Ratio);
fprintf('R [m]                      = %d\n',R);
fprintf('L [m]                      = %d\n',L);

%% Plots
figure(1);
plot(simout.Beta.Time,simout.Beta.Data,'b.-');
grid on;
xlabel('Time [s]');
ylabel('Beta [deg]');
title('Beta');

figure(2);
plot(simout.YawRate.Time,simout.YawRate.Data,'b.-');
grid on;
xlabel('Time [s]');
ylabel('YawRate [deg/s]');
title('YawRate');

figure(3);
plot(simout.GPSLat.Data(3:end),simout.GPSLon.Data(3:end),'b.-');
axis equal;
grid on;
xlabel('Latitude [deg]');
ylabel('Longitude [deg]');
title('Path');

figure(4);
plot(simout.SteeringWheel.Time,simout.SteeringWheel.Data,'b.-');
grid on;
xlabel('Time [s]');
ylabel('SteeringWheel [deg]');
title('SteeringWheel');

figure(5);
plot(simout.WheelAngleL1.Time,simout.WheelAngleL1.Data,'b.-');
hold on;
grid on;
plot(simout.WheelAngleR1.Time,simout.WheelAngleR1.Data,'r.-');
plot(simout.WheelAngleL1.Time,simout.WheelAngleL2.Data,'g.-');
plot(simout.WheelAngleR1.Time,simout.WheelAngleR2.Data,'y.-');
xlabel('Time [s]');
ylabel('Wheel Angles [deg]');
title('Wheel Angles');
legend('L1','R1','L2','R2');


figure(6);
plot(simout.Vx.Time(3:end),simout.Vx.Data(3:end),'b.-');
hold on;
grid on;
plot(simout.VxRef.Time(3:end),simout.VxRef.Data(3:end),'r.-');
xlabel('Time [s]');
ylabel('Vx [Km/h]');
title('Longitudinal Speed');

figure(7);
plot(simout.x.Data(3:end),simout.y.Data(3:end),'b.-');
axis equal;
grid on;
xlabel('x [m]');
ylabel('y [m]');
title('Path');

rmpath('data/logsCarSim_Mercedes_Class_B');