%getPolynomialSteeringRatio
%10/12/2019

close all
clear
clc

addpath('functions');
addpath('data/processedData');

%% Get Dynamic Data
%filenameDynamicData           = 'dataCarSim_Mercedes_Class_B.xlsx';  % Simulation measurements
filenameDynamicData           = 'dataGPS_C4.xlsx';  % GPS measurements
filenameStaticData            = 'dataBank_C4.xlsx'; % Bank measurements
[data, text, raw]    = xlsread(filenameDynamicData,'','','basic');
[data1, text1, raw1] = xlsread(filenameStaticData,'','','basic');

% Remove empty lines
raw1(1 : 5, :) = [];

% data log gps
wheel_angle = data(:,3);  % Wheel Angle [rad]
x           = data(:,2);  % Steering Wheel Angle [rad]
y           = data(:,4);  % Steering Ratio []

%% Get Static Data
[n m]            = size(raw1(:,2));
wheel_angle_rl   = zeros(n,1);
wheel_angle_rr   = zeros(n,1);
wheel_angle_ll   = zeros(n,1);
wheel_angle_lr   = zeros(n,1);
steering_wheel_r = zeros(n,1); 
steering_wheel_l = zeros(n,1); 

for i=1:n
    
     aux = textscan(char(raw1(i,2)),'%s %f %f','Delimiter',{'°','´','´´'});
     aux_grad = str2double(char(aux{1}));
     aux_min = (1 - 2 * ~isempty(strfind(char(aux{1}), '-'))) * aux{2};
     wheel_angle_rl(i) = aux_grad + aux_min/60;
     aux = textscan(char(raw1(i,3)),'%s %f %f','Delimiter',{'°','´','´´'});
     aux_grad = str2double(char(aux{1}));
     aux_min = (1 - 2 * ~isempty(strfind(char(aux{1}), '-'))) * aux{2};
     wheel_angle_rr(i) = aux_grad + aux_min/60;
     aux = textscan(char(raw1(i,5)),'%s %f %f','Delimiter',{'°','´','´´'});
     aux_grad = str2double(char(aux{1}));
     aux_min = (1 - 2 * ~isempty(strfind(char(aux{1}), '-'))) * aux{2};
     wheel_angle_ll(i) = aux_grad + aux_min/60;
     aux = textscan(char(raw1(i,6)),'%s %f %f','Delimiter',{'°','´','´´'});
     aux_grad = str2double(char(aux{1}));
     aux_min = (1 - 2 * ~isempty(strfind(char(aux{1}), '-'))) * aux{2};
     wheel_angle_lr(i) = aux_grad + aux_min/60;
     
     steering_wheel_r(i) = raw1{i,1};
     steering_wheel_l(i) = raw1{i,4};
           
end

steering_wheel = [steering_wheel_r ; steering_wheel_l];
wheel_angle_l  = -[wheel_angle_rl ; wheel_angle_ll]; 
wheel_angle_r  = [wheel_angle_rr ; wheel_angle_lr];
wheel_angle_   = (wheel_angle_l + wheel_angle_r )/2;

% Select valid data 
indexValid = logical((abs(wheel_angle_)>=5).* (abs(steering_wheel) <400));

[n m] = size(x);

%% Get Steering Ratio whith Linear Regression [y = theta0 + theta1*x^1 + theta2*x^2] Steering Wheel Angle
f = @(theta,x) theta(1)*x.^0 + theta(2)*x.^1 + theta(3)*x.^2;
X = [ones(n,1),x.^1,x.^2];
afS= normalEqn(X,y);

%% Get Steering Ratio whith Linear Regression [y = theta0 + theta1*x^1 + theta2*x^2] Wheel Angle
f1 = @(theta,wheel_angle) theta(1)*wheel_angle.^0 + theta(2)*wheel_angle.^1 + theta(3)*wheel_angle.^2;
X = [ones(n,1),wheel_angle.^1,wheel_angle.^2];
af = normalEqn(X,y);

%% Plots
index = find(x >=0);
deltaS = linspace(-10,10,50);         % Steering Wheel Angle
delta  = linspace(-0.7854,0.7854,50); % Wheel Angle
steeringRatioS = f(afS,deltaS);
steeringRatio = f1(af,delta);

% Steering Ratio vs Steering Wheel Angle
figure;
%---- plot dynamic Steering Ratio ----%
%plot(rad2deg(abs(x)),y,'b.');
plot(rad2deg(x),y,'b.');
hold on
plot(rad2deg(deltaS),steeringRatioS,'r.-');
%---- plot static Steering Ratio ----%
%plot(steering_wheel(indexValid),steering_wheel(indexValid)./wheel_angle_(indexValid),'k*');
title('Steering Ratio [5 Km/h]');
ylabel('Steering Ratio []');
xlabel('Steering Wheel Angle[deg]');
grid on;

% Steering Ratio vs Wheel Angle
figure;
%---- plot dynamic Steering Ratio ----%
plot(rad2deg(wheel_angle),y,'b.');
hold on
plot(rad2deg(delta),steeringRatio,'r.-');

title('Steering Ratio [5 Km/h]');
ylabel('Steering Ratio []');
xlabel('Wheel Angle[deg]');
grid on;

% Steering Wheel Angle vs Wheel Angle
figure;
%---- plot dynamic Wheel Angle ----%
plot(rad2deg(wheel_angle),rad2deg(data(:,2)),'b.');
hold on;
%---- plot static Wheel Angle ----%
% plot(wheel_angle_l((indexValid)),steering_wheel((indexValid)),'r.');
% plot(wheel_angle_r((indexValid)),steering_wheel((indexValid)),'g*');
plot(wheel_angle_((indexValid)),steering_wheel((indexValid)),'k.');
% % plot(wheel,rad2deg(steering_wheel_angle),'m.-');
ylabel('Steering Wheel Angle[deg]');
xlabel('Wheel Angle[deg]');
grid on;

% Polynomial
fprintf('Function of Steering Ratio at %d Km/h aprox\n', 5.0);
fprintf('x = Steering Wheel Angle [rad] \n');
fprintf('y = Steering Ratio [] \n');
fprintf('steeringRatioS = %d + %d*deltaS^1 + %d*deltaS^2 \n',afS(1),afS(2),afS(3));
fprintf('steeringRatio = %d + %d*delta^1 + %d*delta^2 \n',af(1),af(2),af(3));    

rmpath('functions');
rmpath('data/processedData');
