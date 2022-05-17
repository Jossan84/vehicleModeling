% plotSingleTrackModel
% 29/03/2019

% Solutions
Solution1 = xSol;
Solution2 = xSol2;
Solution3 = xSol3;

% Test objective function with the Solution
figure;
varTest = 18000 : 100 : 22000;%-30000 : 100 : 30000;
fvarTest = zeros(1, length(varTest));
for i = 1 : length(varTest)
    %fvarTest(i) = f([varTest(i), 30000, 2, 3, 16, 1000]);
    fvarTest(i) = f([varTest(i), Solution3(2 : end)]);
end
plot(varTest, fvarTest, 'b.-', Solution3(1), f(Solution3), 'r*');
ylabel('f []');
xlabel('varTest');

% Plot inputs
figure;
index = (1 : n)';
plot(t, v_x, 'b.-');
ylabel('Vx [m/s]');
xlabel('Time [s]');

plot(t, delta_s, 'b.-');
ylabel('delta_s [rad]');
xlabel('Time [s]');

% Compare Get Data Sates with the simulation made with the parameters 
% obtained from linear regression.
figure;
plot(t, v_y(2 : end), 'b.-', t, v_y_reg(2 : end), 'r.-');
title('Vy Data vs Estimation');
ylabel('Vy [m/s]');
xlabel('Time [s]');

figure;
title('Yaw rate Data vs Estimation');
plot(t, yawRate(2 : end), 'b.-', t, yawRate_reg(2 : end), 'r.-');
ylabel('yaw rate [rad/s]');
xlabel('Time [s]');

% Plot global trajectory.
figure;
ax = gca;
axis(ax, 'equal');
hold(ax, 'on');
plot(ax, x_G, y_G, 'b.-');
xlabel('x [m]');
ylabel('y [m]');

% Plot Solution
fprintf('C_f = %d [N/rad]\n',Solution3(1));
fprintf('C_r = %d [N/rad]\n',Solution3(2));
fprintf('l_f = %d [m]\n',Solution3(3));
fprintf('l_r = %d [m]\n',Solution3(4));
fprintf('Steering Ratio = %d []\n',Solution3(5));
fprintf('Iz = %d [N m s^2]\n',Solution3(6));





