
close all;

addpath('Z:/Workspace/Tools/Library/TestSingleTrackModel/data')
addpath('Z:/Workspace/Tools/Library/TestSingleTrackModel/functions')

load('20190205_log_manual_1.mat');


%% Get Data
latitude = struct;
latitude.Data = BUS_PRIVADO__GPS_2__gps_latitude_______________________________(:,2);
latitude.Time = BUS_PRIVADO__GPS_2__gps_latitude_______________________________(:,1);
latitude = timeseries(latitude.Data,latitude.Time);

longitude = struct;
longitude.Data = BUS_PRIVADO__GPS_2__gps_longitude______________________________(:,2);
longitude.Time = BUS_PRIVADO__GPS_2__gps_longitude______________________________(:,1);
longitude = timeseries(longitude.Data,longitude.Time);

Heading = struct;
Heading.Time = BUS_PRIVADO__GPS_1__gps_heading________________________________(:,1);
Heading.Data = BUS_PRIVADO__GPS_1__gps_heading________________________________(:,2);
Heading = timeseries(Heading.Data,Heading.Time);

steering_wheel = struct;
steering_wheel.Data = SOUS_CAPOT_IS_438__IS_DYN_VOL_305__ANGLE_VOLANT________________(:,2);
steering_wheel.Time = SOUS_CAPOT_IS_438__IS_DYN_VOL_305__ANGLE_VOLANT________________(:,1);
steering_wheel = timeseries(steering_wheel.Data,steering_wheel.Time);
steering_wheel = resampleSignal(steering_wheel,20);

vehicle_speed = struct;
vehicle_speed.Data = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_____(:,2);
vehicle_speed.Time = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_____(:,1);
vehicle_speed = timeseries(vehicle_speed.Data,vehicle_speed.Time);
vehicle_speed = resampleSignal(vehicle_speed,20);

yaw_rate = struct;
yaw_rate.Data = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__VITESSE_LACET______________(:,2);
yaw_rate.Time = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__VITESSE_LACET______________(:,1);
yaw_rate  = timeseries(yaw_rate.Data,yaw_rate.Time);
yaw_rate = resampleSignal(yaw_rate,20);

lateral_acceleration = struct;
lateral_acceleration.Data = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__ACCEL_LAT__________________(:,2);
lateral_acceleration.Time = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__ACCEL_LAT__________________(:,1);
lateral_acceleration = timeseries(lateral_acceleration.Data,lateral_acceleration.Time);

longitudinal_acceleration = struct;
longitudinal_acceleration.Data = SOUS_CAPOT_IS_438__IS_DYN_ABR_38D__ACCEL_LONGI_ROUES___________(:,2);
longitudinal_acceleration.Time = SOUS_CAPOT_IS_438__IS_DYN_ABR_38D__ACCEL_LONGI_ROUES___________(:,1);
longitudinal_acceleration = timeseries(longitudinal_acceleration.Data,longitudinal_acceleration.Time);

longitudinal_speed_I = struct;
longitudinal_speed_I.Data = SOUS_CAPOT_IS_438__IS_DYN4_FRE_30D__VITESSE_ROUE_ARG_NF________(:,2);
longitudinal_speed_I.Time = SOUS_CAPOT_IS_438__IS_DYN4_FRE_30D__VITESSE_ROUE_ARG_NF________(:,1);
longitudinal_speed_I = timeseries(longitudinal_speed_I.Data,longitudinal_speed_I.Time);
longitudinal_speed_I = resampleSignal(longitudinal_speed_I,20);

longitudinal_speed_D = struct;
longitudinal_speed_D.Data = SOUS_CAPOT_IS_438__IS_DYN4_FRE_30D__VITESSE_ROUE_ARD_NF________(:,2);
longitudinal_speed_D.Time = SOUS_CAPOT_IS_438__IS_DYN4_FRE_30D__VITESSE_ROUE_ARD_NF________(:,1);
longitudinal_speed_D = timeseries(longitudinal_speed_D.Data,longitudinal_speed_D.Time);
longitudinal_speed_D = resampleSignal(longitudinal_speed_D,20);

%% GPS Speed
speed_gps = struct;
speed_gps.Time = BUS_PRIVADO__GPS_1__gps_velocity_______________________________(:,1);
speed_gps.Data = BUS_PRIVADO__GPS_1__gps_velocity_______________________________(:,2);
speed_gps  = timeseries(speed_gps.Data,speed_gps.Time);

%% From Global to Local Coordinates

first_position_index  = 1;
end_position_index    = 450;
first_latitude = latitude.Data(first_position_index);
first_longitude = longitude.Data(first_position_index);

spheroid = referenceEllipsoid('GRS 80');

%% Get global positions
[x,y,z]= geodetic2enu(latitude.Data(first_position_index:end_position_index),longitude.Data(first_position_index:end_position_index),0,...
                               first_latitude,first_longitude,0,spheroid);
%% Get yaw
yaw = deg2rad(90 - Heading.Data(first_position_index:end_position_index));


steering_ratio = 15.8;                           
vx          = vehicle_speed.Data(first_position_index : end_position_index);
wheel_angle = deg2rad(steering_wheel.Data(first_position_index : end_position_index)*(1/steering_ratio));

%% Deletle zeros

index = find(vx <= 5);
vx(index) = 7.083490204227284;
vx = vx/3.6;

%% Test obtain Yaw from GPS
% x_local   = x;%(diff(x));
% y_local   = y;%(diff(y));
% x_local =[0; x_local];
% y_local =[0; y_local];
% 
% [n m] = size(x_local);
% yaw_local = zeros(1,n);
% 
% for i=2:n
%     
%    yaw_local(i) = (atan2(x_local(i-1)-x_local(i),y_local(i-1)-y_local(i)));
%     
% end
% 
% x_global = zeros(1, n);
% y_global = zeros(1, n);
% yaw_global = zeros(1, n);
% x_global(1) = 0;
% y_global(1) = 0;
% yaw_global(1) = 0;
% 
% 
% for i = 2 : n
%     X = [x_local(i-1)-x_local(i); y_local(i-1)-y_local(i)];
%     R = [cos(yaw_global(i - 1)), -sin(yaw_global(i - 1)); sin(yaw_global(i - 1)), cos(yaw_global(i - 1))];
%     X = R * X;
%     x_global(i)   = x_global(i - 1) + X(1, 1);
%     y_global(i)   = y_global(i - 1) + X(2, 1);
%     yaw_global(i) = yaw_global(i - 1) + yaw_local(i - 1);
% end
% 



%% Clean workspace
clearvars -except  x y z vx wheel_angle Ts steering_wheel longitudinal_acceleration lateral_acceleration yaw_rate ...
                   vehicle_speed Heading longitude latitude speed_gps yaw longitudinal_speed_D longitudinal_speed_I
               
 

              