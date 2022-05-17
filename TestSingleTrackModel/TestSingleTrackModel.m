
%% Vehicle parameters
%---------------------------------------------------
m  = 1300;     % Vehicle mass [kg]
J  = 1500;     % Vehicle inertia [kgm^2]
c1 = 80000;    % Front wheel cornering stiffness [kgm/s^2]
c2 = 80000;    % Rear wheel cornering stiffness [kgm/s^2
a  = 1.3295;   % Vehicle length, front wheel to center of gravity [m]
b  = 1.3295;   % Vehicle length, rear wheel to center of gravity [m]

%% Definir parámetros
% Parameters
n  = 2000;                 % Number of iterations 
Ts = 0.05;                 % Sample Time [s]
k  = 1;                    % Init step []
t  = linspace(1,n,n) * Ts; % Time [s]

%% Inputs
steering_wheel = deg2rad(60);                     % Steering wheel angle [rad]
steering_ratio = 15.8;                            % Steering Ratio []
u              = steering_wheel / steering_ratio; % Wheel angle [rad]
vx             = 25 / 3.6;                        % Longitudinal velocity [m/s]
%% States
vy       = zeros(1, n);     % Lateral velocity [m/s]
yaw_rate = zeros(1, n);     % Yaw_Rate [rad/s]
X        = [vy; yaw_rate];  % States
dX       = [0; 0];          % Derivative state 

%% System

A=[ -(c1 + c2)/(m*vx),     - vx - (a*c1 - b*c2)/(m*vx);
    -(a*c1 - b*c2)/(J*vx), -(c1*a^2 + c2*b^2)/(J*vx)];

B=[c1/m,(a*c1)/J]';


%% Initialize States [Equilibrium point]
syms V_y Yaw_rate
f        =   solve(A(1,1) * V_y + A(1,2) * Yaw_rate + B(1) * u,...
                   A(2,1) * V_y + A(2,2) * Yaw_rate + B(2) * u);

X(1,1)   = f.V_y;               % Init vy [m/s]
X(2,1)   = f.Yaw_rate;          % Init yaw rate [rad/s]

%% Outputs

for k=1:n-1
    
    dX        = A * X(:,k) + B * u;
    X(:,k+1)  = X(:,k) +  dX * Ts;
    
end

%% Plot States

figure(1);
plot(t,X(1,:),'b.-');
title('Vy');
xlabel('Time [s]');
ylabel('[m/s]');
grid on;

figure(2);
plot(t,X(2,:),'b.-');
title('Yaw rate');
xlabel('Time [s]');
ylabel('[rad/s]');
grid on;

%% Get Positions

x_L   = vx * Ts * ones(1, n);
y_L   = X(1,1:end-1) * Ts;
yaw_L = X(2,1:end-1) * Ts;

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
grid(ax, 'on');
hold(ax, 'on');

for i = 1 : n
    plotVehiclePose(ax, x_G(i), y_G(i), yaw_G(i));
end

