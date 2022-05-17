

% Vehicle parameters
%---------------------------------------------------

m=1300;             % Vehicle mass [kg]
J=1500;             % Vehicle inertia [kgm^2]
c1=100000;           % Front wheel cornering stiffness [kgm/s^2]
c2=80000;           % Rear wheel cornering stiffness [kgm/s^2
a=1.3295;           % Vehicle length, front wheel to center of gravity [m]
b=1.3295;           % Vehicle length, rear wheel to center of gravity [m]
tau=0.1;            % Actuator time constant [s]
k1=0.01;            % Actuator gain 1 [rad/V]
k2=0.0056;          % Actuator gain 2 [rad/V^3]    


%---------------------------------------------------
% vehicle forward velocity
%---------------------------------------------------
vx= 7/3.6;               % Vehicle velocity [m/s]

%---------------------------------------------------
% Enter your A and B matrices here
%---------------------------------------------------
A=[ 0,                     1,      vx,                           0;
    0,     -(c1 + c2)/(m*vx),       0, - vx - (a*c1 - b*c2)/(m*vx);
    0,                     0,       0,                           1;
    0, -(a*c1 - b*c2)/(J*vx),       0,   -(c1*a^2 + c2*b^2)/(J*vx)];

B=[0 c1/m 0 (a*c1)/J]';
C=eye(4);
D=[0; 0; 0; 0];


% Discrete System
Ts = 0.01;
system = ss(A,B,C,D);
tf_system = tf(system);
tf_systemd = c2d(tf_system,Ts);

