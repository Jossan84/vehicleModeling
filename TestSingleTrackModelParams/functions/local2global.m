function [ x_G, y_G, yaw_G ] = local2global( v_x, v_y, yawRate, x_G_Init, y_G_Init, yaw_G_Init, Ts)

%% Initialization
[m, n] = size(v_x);

x_G = zeros(1, m);
y_G = zeros(1, m);
yaw_G = zeros(1, m);
x_G(1) = x_G_Init;
y_G(1) = y_G_Init;
yaw_G(1) = yaw_G_Init;


%% From Local to Global
for i = 2 : m
    X = [v_x(i - 1) * Ts; v_y(i - 1) * Ts];
    R = [cos(yaw_G(i - 1)), -sin(yaw_G(i - 1)); sin(yaw_G(i - 1)), cos(yaw_G(i - 1))];
    X = R * X;
    x_G(i) = x_G(i - 1) + X(1, 1);
    y_G(i) = y_G(i - 1) + X(2, 1);
    yaw_G(i) = yaw_G(i - 1) + Ts * yawRate(i - 1);
end


end

