% TestVehicle.m
% 16/10/2019

close all;
clear;
more off;
clc;

%% Definir parámetros
n = 125;  %[Steps]
T = 0.2;  %[s] 
vx = 1;   %[m/s]
vy = 0;   %[m/s]
Rc = 4;   %[m]
yawRate = vx/Rc; %[rad/s]

%% Inicializar
% Memorias
x_G   = zeros(1, n);
y_G   = zeros(1, n);
yaw_G = zeros(1, n);
% Posición Inicial
x_G(1)   = 0;
y_G(1)   = 0;
yaw_G(1) = 0;

%% Convertir coordenadas locales a globales [Primera aproximación movimiento geometrico vehiculo]
%  Descomentar para probar
% x_L = vx * T * ones(1, n - 1);
% y_L = vy * T * ones(1, n - 1);
% yaw_L = yawRate * T * ones(1, n - 1);

% for k = 2 : n
%     X = [x_L(k - 1); y_L(k - 1)];
%     R = [cos(yaw_G(k - 1)), -sin(yaw_G(k - 1)); sin(yaw_G(k - 1)), cos(yaw_G(k - 1))];
%     X = R * X;
%     x_G(k) = x_G(k - 1) + X(1, 1);
%     y_G(k) = y_G(k - 1) + X(2, 1);
%     yaw_G(k) = yaw_G(k - 1) + yaw_L(k - 1);
% end

%% Convertir coordenadas locales a globales [Segunda aproximación movimiento geometrico vehiculo]
for k = 2 : n
    
    % Incrementos de posición y yaw
    deltaYaw = yawRate * T;
    X = [vx * T; vy * T];
    % Translación
    R = [cos(deltaYaw/2), -sin(deltaYaw/2); sin(deltaYaw/2), cos(deltaYaw/2)];  
    X = R * X;
    % Rotación 
    R = [cos(yaw_G(k-1)), -sin(yaw_G(k-1)); sin(yaw_G(k-1)), cos(yaw_G(k-1))];
    X = R * X;
    % Actualización de la nueva posición con los incrementos 
    x_G(k) = x_G(k - 1) + X(1, 1);
    y_G(k) = y_G(k - 1) + X(2, 1);
    yaw_G(k) = yaw_G(k - 1) + deltaYaw;        
end

%% Plot
figure;
ax = gca;

for k = 1 : n
    
    plot(ax,x_G(1:k),y_G(1:k),'b.-');
    hold(ax, 'on');
    plotVehiclePose(ax, x_G(k), y_G(k), yaw_G(k));
    axis(ax, [-Rc-1,Rc+1, 0, 2*Rc]);
    pause(0.2);
    hold(ax, 'off');
    
end
axis(ax, 'equal');
grid(ax, 'on');
%%
