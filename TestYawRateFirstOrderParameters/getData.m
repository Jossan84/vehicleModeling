%getData
%25/10/2019

close all;
clear;
more off;
clc;

addpath('data');

% Load Data
load('20191015_068_.mat');

T = 40e-3; %[s]
steeringRatio = 16; % []
L = 2.728; % [m]

deltaS = struct;
deltaS.Time = SOUS_CAPOT_IS_438__IS_DYN_VOL_305__ANGLE_VOLANT________________(:,1);
deltaS.Data = deg2rad(SOUS_CAPOT_IS_438__IS_DYN_VOL_305__ANGLE_VOLANT________________(:,2));

vx = struct;
vx.Time = SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_____(:,1);
vx.Data = (SOUS_CAPOT_IS_438__IS_VROUES_ABR_44D__VITESSE_VEH_ROUES_AV_____(:,2))/3.6;

yawRate = struct;
yawRate.Time = SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__VITESSE_LACET______________(:,1);
yawRate.Data = deg2rad(SOUS_CAPOT_IS_438__IS_DYN2_FRE_3CD__VITESSE_LACET______________(:,2));

deltaDesiredS = struct; 
deltaDesiredS.Time = BUS_PRIVADO__AVP_data__desired_angle___________________________(:,1);
deltaDesiredS.Data = deg2rad(BUS_PRIVADO__AVP_data__desired_angle___________________________(:,2));

%interpolationMethod = 'previous';
interpolationMethod = 'linear';

startTime = 130; 
endTime   = 159;

time = (startTime : T : endTime)';

deltaS  = interp1(deltaS.Time, deltaS.Data, time, interpolationMethod); % [rad]
vx      = interp1(vx.Time, vx.Data, time, interpolationMethod); % [m/s]
yawRate = interp1(yawRate.Time, yawRate.Data, time, interpolationMethod); % [rad/s]
deltaDesiredS = interp1(deltaDesiredS.Time, deltaDesiredS.Data, time, interpolationMethod); % [rad]
delta = deltaS/steeringRatio;
deltaDesired = deltaDesiredS/steeringRatio; 

clearvars -except deltaS vx yawRate deltaDesiredS delta deltaDesired L steeringRatio T time 

rmpath('data');