
% Load parameters
% Get_data;
addpath('Z:/Workspace/Tools/Library/TestSingleTrackModel/functions');

%% Get Data
GetData;
[o p] = size(vx);

%% Vehicle parameters
%---------------------------------------------------

m=1300;             % Vehicle mass [kg]
J=1500;             % Vehicle inertia [kgm^2]
c1=80000;           % Front wheel cornering stiffness [kgm/s^2]
c2=80000;           % Rear wheel cornering stiffness [kgm/s^2
a=1.3295;           % Vehicle length, front wheel to center of gravity [m]
b=1.3295;           % Vehicle length, rear wheel to center of gravity [m]


%% Parameters Inicialization
n = o; % Number of iterations
vy       = zeros(1, n - 1); % Lateral velocity [m/s]
yaw_rate = zeros(1, n - 1); % Yaw_Rate [rad/s]

%% Simulation Step

% Input [Steering Wheel]
u = wheel_angle;

for i=1:n-1
    
    % System model Continuous
    A=[ 0,                        1,   vx(i),                                 0;
        0,     -(c1 + c2)/(m*vx(i)),       0, - vx(i) - (a*c1 - b*c2)/(m*vx(i));
        0,                        0,       0,                                 1;
        0, -(a*c1 - b*c2)/(J*vx(i)),       0,     -(c1*a^2 + c2*b^2)/(J*vx(i))];

    B=[0 c1/m 0 (a*c1)/J]';
    C=eye(4);
    D=[0; 0; 0; 0];

    % System Discretization:
    Ts = 0.05;
    sys = ss(A,B,C,D);
    sys_d = c2d(sys,Ts,'zoh'); 
    
    % Compute Discrete Model:
    vy(i+1)       = sys_d.A(2,2)*(vy(i)) + sys_d.A(2,4)*(yaw_rate(i)) + sys_d.B(2)* u(i);
    yaw_rate(i+1) = sys_d.A(4,2)*(vy(i)) + sys_d.A(4,4)*(yaw_rate(i)) + sys_d.B(4)* u(i);

    % Compute Experimental model:
    %vy(i+1)       = (-3.4945)*(vy(i)) + (2.245411)*(yaw_rate(i)) + (0.889622)* u(i);
    %yaw_rate(i+1) = (-0.269925)*(vy(i)) + (-1.575934)*(yaw_rate(i)) + (0.724596)* u(i);
    
end

%% Plot coordinates

x_L = vx * Ts * ones(1, n);
y_L = vy * Ts;
yaw_L = yaw_rate * Ts;

%% Inicializar
x_G = zeros(1, n);
y_G = zeros(1, n);
yaw_G = zeros(1, n);
x_G(1) = 0;
y_G(1) = 0;
yaw_G(1) = deg2rad(90-216);

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

%% Plot Yaw

figure(2);
plot3(x_G,y_G,yaw_G,'b.-');
hold on;
grid
plot3(x,y,yaw,'r.-');
ylabel('x [m]');
xlabel('y [m]');
zlabel('\Psi [rad]');

figure(3);
plot(x_G,y_G,'b.-');
hold on;
grid
plot(x,y,'r.-');
ylabel('x [m]');
xlabel('y [m]');




