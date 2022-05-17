
close all

GetData;

%% Plots
figure(1);
plot(steering_wheel.Time,steering_wheel.Data,'b.-');
title('Steering Wheel Angle');
xlabel('Time [s]');
ylabel('deg');

figure(2);
plot(latitude.Data,longitude.Data,'b.-');
title('Global Position');
xlabel('latitude');
ylabel('longitude');

figure(3);
plot(vehicle_speed.Time,vehicle_speed.Data,'b.-');
hold on;
plot(speed_gps.Time,speed_gps.Data,'r.-');
title('Vehicle Speed');
xlabel('Time [s]');
ylabel('kmh');

figure(4);
plot(x,y,'b.-');
hold on;
plot(0,0,'r.-');
hold off;
title('Local Position');
axis equal;grid on;
xlabel('m');
ylabel('m');

figure(5);
plot(yaw_rate.Time,yaw_rate.Data,'b.-');
title('Yaw rate');
xlabel('Time [s]');
ylabel('deg');

figure(6);
plot(lateral_acceleration.Time,lateral_acceleration.Data,'b.-');
title('lateral acceleration');
xlabel('Time [s]');
ylabel('m/s^2');

figure(7);
plot(longitudinal_acceleration.Time,longitudinal_acceleration.Data,'b.-');
title('longitudinal acceleration');
xlabel('Time [s]');
ylabel('m/s^2');


%% Calculate Radius

R = vehicle_speed.Data./deg2rad(yaw_rate.Data);

%%
figure(8);
plot(yaw_rate.Time,R,'b.-');
hold on;
title('R');
xlabel('Time [s]');
ylabel('[m]');
ylim([18 32]);
xlim([18 30]);

figure(9);
plot(Heading.Time,Heading.Data,'b.-');
title('Heading');
xlabel('Time [s]');
ylabel('[deg]');


