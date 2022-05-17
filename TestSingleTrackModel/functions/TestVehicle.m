% TestVehicle.m
% 07/02/2019

close all;
clear;
more off;
clc;
%% Definir parámetros
n = 70;
T = 1;
vx = 10;
vy = 0;
radius = 100;
yaw_rate = vx/radius;
x_L = vx * T * ones(1, n - 1);
y_L = vy * T * ones(1, n - 1);
yaw_L = yaw_rate * T * ones(1, n - 1);


%% Inicializar
x_G = zeros(1, n);
y_G = zeros(1, n);
yaw_G = zeros(1, n);
x_G(1) = 0;
y_G(1) = 0;
yaw_G(1) = 0;

%% Convertir coordenadas locales a globales
for i = 2 : n
    X = [x_L(i - 1); y_L(i - 1)];
    R = [cos(yaw_G(i - 1)), -sin(yaw_G(i - 1)); sin(yaw_G(i - 1)), cos(yaw_G(i - 1))];
    X = R * X;
    x_G(i) = x_G(i - 1) + X(1, 1);
    y_G(i) = y_G(i - 1) + X(2, 1);
    yaw_G(i) = yaw_G(i - 1) + yaw_L(i - 1);
end

%% Plot
figure;
ax = gca;
%axis(ax, [-100, 100, -100, 100]);
axis(ax, 'equal');
hold(ax, 'on');

for i = 1 : n
    plotVehiclePose(ax, x_G(i), y_G(i), yaw_G(i));
end

%%
