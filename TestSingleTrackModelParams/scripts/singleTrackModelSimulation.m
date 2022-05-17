% singleTrackModelSimulation
% 29/03/2019


%% Single Track Model Simulation
% This simulation obtain the data needed to compute and test the lineal
% regression. 

%% Set constant parameters
T = 40e-3;% [s]
n = 200;% []
steeringRatio = 16.0;% []
m = 1500;% [kg]
I_z = 1000;% [N m s^2]
C_f = 20000;% [N/rad]
C_r = 30000;% [N/rad]
l = 5;% [m]
l_f = 0.4 * l;% [m]
l_r = 0.6 * l;% [m]
maxSteeringWheelAngle = 75; %[deg]
t = linspace(1,n,n) * T; % [s]

%% Set State-Space System
A = [-(C_f + C_r) / m, (-C_f * l_f + C_r * l_r) / m;
    (-C_f * l_f + C_r * l_r) / I_z, -(C_f * l_f^2 + C_r * l_r^2) / I_z];
B = [C_f / m;
    C_f * l_f / I_z] / steeringRatio;

%% Set inputs
% delta_s = steeringInput(maxSteeringWheelAngle,n);
% delta_s = deg2rad(randi(maxSteeringWheelAngle, n, 1) .* rand(n, 1));
delta_s = sineSteeringInput(maxSteeringWheelAngle,n,T)';
delta_s = addNoise2Signal(0.05,0.1,delta_s);             % Add noise
v_x = 30 / 3.6 * ones(n, 1);% [m/s]

%% Initialization
v_y = zeros(n + 1, 1);% [m/s]
yawRate = zeros(n + 1, 1);% [rad/s]
v_y(1) = (725 * pi / 13968) * 0;
yawRate(1) = (25 * pi / 776) * 0;

dv_y_output = zeros(n, 1);
dyawRate_output = zeros(n, 1);

X = [v_y(1);
    yawRate(1)];

%% Generate outputs
%  Update the model to obtain the states
for k = 1 : n
    % Update A(k)
    A_k = A * (1 / v_x(k)) + [0, -v_x(k); 0, 0];
    
    X = addNoise2Signal(0,0.1,X);    % Add noise
    v_y(k + 1) = X(1);
    yawRate(k + 1) = X(2);
    dX = A_k * X + B * delta_s(k);
    dv_y_output(k, 1) = dX(1);
    dyawRate_output(k, 1) = dX(2);
    X = X + T * dX;
end

%% Sensor measurements
dv_y_sensor     = dv_y_output;
dyawRate_sensor = dyawRate_output;
v_x_sensor      = v_x;
v_y_sensor      = v_y(2 : end);
yawRate_sensor  = yawRate(2 : end);

