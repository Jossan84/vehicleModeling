
clear
close all;
clc

load('20190404_logs_autopista_manual_1.mat')

%% Set constant parameters
T = 50e-3;% [s]
m = 1400;% [kg]
F = 20;

%% Get Data
% {vx, v_y, dv_y, yawRate,dyawRate, delta_s}

%------------------- Data ----------------------
% delta_s
delta_s = struct;
delta_s.Data = SOUS_CAPOT_IS_438__IS_DYN_VOL_305__ANGLE_VOLANT________________(:,2);
delta_s.Time = SOUS_CAPOT_IS_438__IS_DYN_VOL_305__ANGLE_VOLANT________________(:,1);
delta_s = timeseries(deg2rad(delta_s.Data),delta_s.Time);
delta_s = resampleSignal(delta_s,F);

v_xD = struct;
v_xD.Data = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_ROUE_ARD_________(:,2);
v_xD.Time = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_ROUE_ARD_________(:,1);
v_xD = timeseries(v_xD.Data,v_xD.Time);
v_xD = resampleSignal(v_xD,F);

v_xI = struct;
v_xI.Data = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_ROUE_ARG_________(:,2);
v_xI.Time = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_ROUE_ARG_________(:,1);
v_xI = timeseries(v_xI.Data,v_xI.Time);
v_xI = resampleSignal(v_xI,F);

% yawRate
yawRate = struct;
yawRate.Data = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__VITESSE_LACET______________(:,2);
yawRate.Time = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__VITESSE_LACET______________(:,1);
yawRate  = timeseries(yawRate.Data,yawRate.Time);
yawRate = resampleSignal(yawRate,F);

% dyawRate
dyawRate = struct;
dyawRate.Time = yawRate.Time;
dyawRate.Data = [0; diff(yawRate.Data)];
dyawRate = timeseries(dyawRate.Data, dyawRate.Time);

% v_x
v_x = struct;
v_x.Data = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_____(:,2);
v_x.Time = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_____(:,1);
v_x = timeseries(v_x.Data,v_x.Time);
v_x = resampleSignal(v_x,F);


%-------------------------- Global representation -----------------------
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

%% GPS Speed
v_gps = struct;
v_gps.Time = BUS_PRIVADO__GPS_1__gps_velocity_______________________________(:,1);
v_gps.Data = BUS_PRIVADO__GPS_1__gps_velocity_______________________________(:,2);
v_gps  = timeseries(v_gps.Data,v_gps.Time);

%% From Global to Local Coordinates

first_position_index  = 1;
end_position_index    = 600;
first_latitude = latitude.Data(first_position_index);
first_longitude = longitude.Data(first_position_index);
n = end_position_index;% []

spheroid = referenceEllipsoid('GRS 80');

%% Get global positions
[x,y,z]= geodetic2enu(latitude.Data(first_position_index:end_position_index),longitude.Data(first_position_index:end_position_index),0,...
                               first_latitude,first_longitude,0,spheroid);
                          

%% Sensor measurements
dyawRate_sensor = dyawRate.Data(1:n);
v_x_sensor      = v_x.Data(1:n);
yawRate_sensor  = yawRate.Data(1:n);
v_x_gps_sensor  = v_gps.Data(1:n);
delta_s         = delta_s.Data(1:n);

%% Beta
startTime_rect  = 1;
endTime_rect    = 15 / T;
startTime_curve = 20 / T;
endTime_curve   = 30 / T;

% Factor
factor = mean(v_xI.Data(startTime_rect:endTime_rect)) ./ ...
         mean(v_x_gps_sensor(startTime_rect:endTime_rect));

for i = 1:endTime_curve
    if (v_xI.Data(i) <= 0.9910*v_x_gps_sensor(i)) && (i > startTime_curve)
        beta(i) = acos(v_xI.Data(i) ./ (0.9910 * v_x_gps_sensor(i)));
        v_y(i)  = v_xI.Data(i) * tan(beta(i));
    else
        beta(i) = NaN;
        v_y(i) = NaN;
    end
end


% Plot velocity
figure(1);
plot(v_x.Time,v_x.Data,'r.-');
hold on;
plot(v_gps.Time,v_gps.Data,'b.-');
plot(v_xI.Time(startTime_curve:endTime_curve),v_xI.Data(startTime_curve:endTime_curve),'g.-');
plot(v_xD.Time(startTime_curve:endTime_curve),v_xD.Data(startTime_curve:endTime_curve),'k.-');
xlabel('Time [s]');
ylabel('[km/h]');

% Plot Beta
figure(2);
plot((startTime_rect:endTime_curve).*T,beta,'b.-');
xlabel('Time [s]');
ylabel('[rad]');

% Plot Vy
figure(3);
plot((startTime_rect:endTime_curve).*T,v_y,'b.-');
xlabel('Time [s]');
ylabel('[m/s]');

% Beta Mean
beta = beta(~isnan(beta));
% beta = mean(beta);
% beta = rad2deg(beta);

%% Clean workspace
clearvars -except delta_s dv_y_sensor dyawRate_sensor v_x_sensor...
                  x y v_y_sensor yawRate_sensor a_y a_x n m T ...
                  v_x_gps v_x_gps_sensor factor beta v_xD v_xI
