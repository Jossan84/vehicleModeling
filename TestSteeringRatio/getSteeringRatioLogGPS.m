
close all
clear
clc

addpath('data/logsGPS_C4');
load('20181005_logs_pistas_mat_19.mat');

%% Get Data
latitude = BUS_PRIVADO__GPS_2__gps_latitude_______________________________(:,2);
longitude = BUS_PRIVADO__GPS_2__gps_longitude______________________________(:,2);

heading       =  BUS_PRIVADO__GPS_1__gps_heading________________________________(:,2);
heading_time  =  BUS_PRIVADO__GPS_1__gps_heading________________________________(:,1);
heading = timeseries(heading,heading_time);

yaw_rate      =  SOUS_CAPOT_IS_438_MOD__IS_DYN2_FRE_3CD__VITESSE_LACET__________(:,2);
yaw_rate_time =  SOUS_CAPOT_IS_438_MOD__IS_DYN2_FRE_3CD__VITESSE_LACET__________(:,1);

yaw_rate = timeseries(yaw_rate,yaw_rate_time);


steerting_wheel = struct;
steerting_wheel.Data = SOUS_CAPOT_IS_438_MOD__IS_DYN_VOL_305__ANGLE_VOLANT____________(:,2);
steerting_wheel.Time = SOUS_CAPOT_IS_438_MOD__IS_DYN_VOL_305__ANGLE_VOLANT____________(:,1);

vehicle_speed = struct;
vehicle_speed.Data = SOUS_CAPOT_IS_438_MOD__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_(:,2);
vehicle_speed.Time = SOUS_CAPOT_IS_438_MOD__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_(:,1);

%% Car Parameters

L = 2.785;   % WheelBase
L_ = 1.4777; % Distance from GPS to rear axe

[m n] = size(steerting_wheel.Data);
angle_test_index = round(m/2);

steering_wheel_angle = deg2rad(steerting_wheel.Data(angle_test_index));

%% From Global to Local Coordinates

first_position_index  = 700;
end_position_index    = 1800;


first_latitude = latitude(first_position_index);
first_longitude = longitude(first_position_index);

spheroid = referenceEllipsoid('GRS 80');

[x,y,z]= geodetic2enu(latitude(first_position_index:end_position_index),longitude(first_position_index:end_position_index),0,...
                               first_latitude,first_longitude,0,spheroid);



%% Turning Radius & Steering Ratio

[m n] = size(x);

for i=1:m-1
    p1 = [x(1) y(1)];
    p2 = [x(i) y(i)];
    d(i) = norm(p1 - p2);   
end
    
diameter = max(abs(d));

R_gps = diameter/2;
R = sqrt((R_gps^2)-(L_^2));

wheel_angle = atan(L/R);
Steering_Ratio = steering_wheel_angle/wheel_angle;

% Another way to obtain the steeringRatio.
Sr = abs(steering_wheel_angle)/atan(sqrt((L^2)/((R_gps^2) - (L_^2))));

%% Display Data
fprintf('Steering Wheel Angle [rad] = %d\n',steering_wheel_angle);
fprintf('Wheel Angle [rad]          = %d\n',wheel_angle);
fprintf('Steering Ratio []          = %d\n',Steering_Ratio);
fprintf('R [m]                      = %d\n',R);
fprintf('L [m]                      = %d\n',L);

%% Plots
figure(1);
plot(steerting_wheel.Time,steerting_wheel.Data,'b.-');
title('Steering Wheel Angle');
grid on;
xlabel('seconds');
ylabel('deg');

figure(2);
plot(latitude,longitude,'b.-');
title('Global Position');
axis equal;grid on;
xlabel('latitude');
ylabel('longitude');

figure(3);
plot(vehicle_speed.Time,vehicle_speed.Data,'b.-');
title('Vehicle Speed');
grid on;
xlabel('seconds');
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
title('yaw rate');
grid on;
xlabel('seconds');
ylabel('deg/s');

%clear;

rmpath('data/logsGPS_C4');

