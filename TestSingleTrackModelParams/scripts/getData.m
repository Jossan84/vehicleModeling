
addpath('Z:/Workspace/Tools/Library/TestSingleTrackModelParams/data');
addpath('Z:/Workspace/Tools/Library/TestSingleTrackModelParams/functions');


load('20190404_logs_autopista_manual_1.mat');

%% Get Data
% {vx, v_y, dv_y, yawRate,dyawRate, delta_s}

%--------------------- Sampled ------------------------- 
T = 0.05;
Fs = 1/T;

%------------------------------ GPS  Status ------------------------------- 
gps_status = struct;
gps_status.Time = BUS_PRIVADO__GPS_1__gps_status_nmea____________________________(:,1); 
gps_status.Data = BUS_PRIVADO__GPS_1__gps_status_nmea____________________________(:,2);
gps_status = timeseries(gps_status.Data,gps_status.Time);
index = find(gps_status.Data == 4);
time = index * 0.05;

%------------------- Car Measurements ----------------------

% delta_s
delta_s = struct;
delta_s.Data = SOUS_CAPOT_IS_438__IS_DYN_VOL_305__ANGLE_VOLANT________________(:,2);
delta_s.Time = SOUS_CAPOT_IS_438__IS_DYN_VOL_305__ANGLE_VOLANT________________(:,1);
delta_s = timeseries(deg2rad(delta_s.Data),delta_s.Time);
delta_s = resampleSignal(delta_s,Fs);

% yawRate
yawRate = struct;
yawRate.Data = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__VITESSE_LACET______________(:,2);
yawRate.Time = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__VITESSE_LACET______________(:,1);
yawRate = timeseries(yawRate.Data,yawRate.Time);
yawRate = resampleSignal(yawRate,Fs);

% dyawRate
dyawRate = struct;
dyawRate.Time = yawRate.Time;
dyawRate.Data = [0; 1/T * diff(yawRate.Data)];
dyawRate = timeseries(dyawRate.Data, dyawRate.Time);
dyawRate = resampleSignal(dyawRate,Fs);

% v_x
v_x = struct;
v_x.Data = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_____(:,2);
v_x.Time = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_____(:,1);
v_x = timeseries(v_x.Data/3.6,v_x.Time);
v_x = resampleSignal(v_x,Fs);


% a_y
a_y = struct;
a_y.Data = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__ACCEL_LAT__________________(:,2);
a_y.Time = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__ACCEL_LAT__________________(:,1);
a_y = timeseries(a_y.Data,a_y.Time);
a_y = resampleSignal(a_y,Fs);


% a_x
a_x = struct;
a_x.Data = SOUS_CAPOT_IS_438__IS_DYN_ABR_38D__ACCEL_LONGI_ROUES___________(:,2);
a_x.Time = SOUS_CAPOT_IS_438__IS_DYN_ABR_38D__ACCEL_LONGI_ROUES___________(:,1);
a_x = timeseries(a_x.Data,a_x.Time);
a_x = resampleSignal(a_x,Fs);


%-------------------------- Global representation -------------------------
latitude = struct;
latitude.Data = BUS_PRIVADO__GPS_2__gps_latitude_______________________________(:,2);
latitude.Time = BUS_PRIVADO__GPS_2__gps_latitude_______________________________(:,1);
latitude = timeseries(latitude.Data,latitude.Time);
%latitude = resampleSignal(latitude,Fs);

longitude = struct;
longitude.Data = BUS_PRIVADO__GPS_2__gps_longitude______________________________(:,2);
longitude.Time = BUS_PRIVADO__GPS_2__gps_longitude______________________________(:,1);
longitude = timeseries(longitude.Data,longitude.Time);
%longitude = resampleSignal(longitude,Fs);

Heading = struct;
Heading.Time = BUS_PRIVADO__GPS_1__gps_heading________________________________(:,1);
Heading.Data = BUS_PRIVADO__GPS_1__gps_heading________________________________(:,2);
Heading = timeseries(Heading.Data,Heading.Time);
%Heading = resampleSignal(Heading,Fs);

%----------------------------------------------------------------------------
% v_y
v_y = struct;
% v_y.Data = cumtrapz(a_y.Time,a_y.Data*T);
v_y.Data = T * cumsum(a_y.Data);
v_y.Time = a_y.Time;
v_y = timeseries(v_y.Data,v_y.Time);


%% GPS Speed
v_x_gps = struct;
v_x_gps.Time = BUS_PRIVADO__GPS_1__gps_velocity_______________________________(:,1);
v_x_gps.Data = BUS_PRIVADO__GPS_1__gps_velocity_______________________________(:,2);
v_x_gps  = timeseries(v_x_gps.Data,v_x_gps.Time);

%% From Global to Local Coordinates

first_position_index  = 1;
end_position_index    = 3000;
first_latitude        = latitude.Data(first_position_index);
first_longitude       = longitude.Data(first_position_index);
n                     = end_position_index;% []

spheroid = referenceEllipsoid('GRS 80');

%% Get global positions
[x,y,z]= geodetic2enu(latitude.Data(first_position_index:end_position_index),longitude.Data(first_position_index:end_position_index),0,...
                               first_latitude,first_longitude,0,spheroid);
                           
x_G_Init = zeros(size(v_x.Data));
y_G_Init = zeros(size(v_x.Data));
yaw_G_Init = pi/2 - deg2rad(Heading.Data(1));

%[x_G, y_G, yaw_G] = local2global( v_x.Data, v_y, yawRate.Data, x_G_Init, y_G_Init, yaw_G_Init, T);


%% Sensor measurements
% dv_y_sensor     = a_y.Data(1:n);
% dyawRate_sensor = dyawRate.Data(1:n);
% v_x_sensor      = v_x.Data(1:n);
% v_y_sensor      = v_y.Data(1:n);
% yawRate_sensor  = yawRate.Data(1:n);
% v_x_gps_sensor  = v_x_gps.Data(1:n)/3.6;
% delta_s         = delta_s.Data(1:n);

% figure(1);
% factor = v_x_sensor ./ v_x_gps_sensor;
% plot(factor .* v_x_gps_sensor, 'b.-');
% hold on;
% plot(v_x_sensor, 'r.-');

figure(1);
plot(x,y,'b.-');
xlim([-500 300]);

%% Set constant parameters
% T = 40e-3;% [s]
% m = 1400;% [kg]

%% Clean workspace
clearvars -except delta_s yawRate v_x dyawRate a_y x y v_y ...
                  x_G y_G yaw_G ...
                  latitude longitude Heading gps_status ...
                  index time
              
