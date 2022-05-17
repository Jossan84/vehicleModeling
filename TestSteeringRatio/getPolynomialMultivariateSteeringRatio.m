%getPolynomialMultivariateSteeringRatio
%10/12/2019

close all
clear
clc

addpath('functions');
addpath('data/processedData');

%% Get Dynamic Data
filenameDynamicData           = 'dataCarSim_Mercedes_Class_B_Multi.xlsx';  % Simulation measurements
%filenameDynamicData           = 'dataGPS_C4.xlsx';  % GPS measurements
filenameStaticData            = 'dataBank_C4.xlsx'; % Bank measurements
[data, text, raw]    = xlsread(filenameDynamicData,'','','basic');
[data1, text1, raw1] = xlsread(filenameStaticData,'','','basic');

% Remove empty lines
raw1(1 : 5, :) = [];

% data log gps
wheel_angle = data(:,3);  % Wheel Angle [rad]
x           = data(:,2);  % Steering Wheel Angle [rad]
y           = data(:,4);  % Steering Ratio []
v           = data(:,5);  % Vehicle Speed [m/s]

[n m] = size(x);

%% Get Steering Ratio whith Linear Regression (One variable)
%% y = theta0 + theta1*x^1 + theta2*x^2 
f = @(theta,x) theta(1)*x.^0 + theta(2)*x.^1 + theta(3)*x.^2;
X = [ones(n,1),x.^1,x.^2];
af = normalEqn(X,y);

%% Get Steering Ratio whith Linear Regression (Multivariable)
%% y = theta0 + theta1*x^1 + theta2*v^1 + theta3*x^2 + theta4*v*x + theta5*v^2
f_m = @(theta,x,v) theta(1)*x.^0 + theta(2)*x.^1 + theta(3)*v.^1 + theta(4)*x.^2 + theta(5)*v.*x + theta(6)*v.^2;
X = [ones(n,1),x.^1,v.^1,x.^2,v.*x,v.^2];
af_m = normalEqn(X,y);

%% Get Steering Ratio whith Linear Regression (Multivariable)
%% f = fit( [x, v], y, 'poly21' )
f_poly = fit( [rad2deg(x), v], y, 'poly21' );

%% Plots
figure;
plot3(rad2deg(x),v,y,'b.');
ylabel('v [Km/h]');
xlabel('Steering Wheel [deg]');
zlabel('Steering Ratio []');
grid on;

delta = linspace(-10,10,50);
speed = 5;

steeringRatio = f(af,delta);
steeringRatio1 = f_m(af_m,delta,speed);

% Steering Ratio vs Steering Wheel Angle
figure;
plot(rad2deg(x),y,'b.');
hold on
plot(rad2deg(delta),steeringRatio,'r.-');
plot(rad2deg(delta),steeringRatio1,'g.-');
title('Steering Ratio');
ylabel('Steering Ratio []');
xlabel('Steering Wheel Angle[deg]');
grid on;

% Steering Wheel Angle vs Wheel Angle
figure;
plot(rad2deg(wheel_angle),rad2deg(data(:,2)),'b.');
ylabel('Steering Wheel Angle[rad]');
xlabel('Wheel Angle[rad]');
grid on;

% Fitting Surface
figure;
plot(f_poly,[rad2deg(x),v],y);
ylabel('v [Km/h]');
xlabel('Steering Wheel [deg]');
zlabel('Steering Ratio []');
grid on;

% Polynomial
fprintf('Function of Steering Ratio\n');
fprintf('x = Steering Wheel Angle [rad] \n');
fprintf('y = Steering Ratio [] \n');
fprintf('y = %d + %d*x^1 + %d*x^2 \n',af(1),af(2),af(3));
fprintf('y_m = %d + %d*x^1 + %d*v^1 + %d*x^2 + %d*v*x + %d*v^2\n',af_m(1),af_m(2),af_m(3),af_m(4),af_m(5),af_m(6));    
f_poly

rmpath('functions');
rmpath('data/processedData');
