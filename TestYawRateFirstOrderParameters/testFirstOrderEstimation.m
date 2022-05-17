%testFirstOrderEstimation
%25/10/2019

close all;
clear;
more off;
clc;

addpath('functions');

%% Get Data
getData;

%% Transfer Function for Linear Regression
% Equation
% yawRate(k+1) = a*yawRate(k) + b*(vx(k)/L)*tan(delta(k));

% Delay
% tDelay = 80e-3;
tDelay = 0;
d = floor(tDelay/T);

% Estimate a,b
Y = yawRate(2+d:end);
X = [yawRate(1:end-1-d),vx(1:end-1-d)/L .* tan(deltaDesired(1:end-1-d))];
[theta] = normalEqn(X, Y);
J = costFunction(X, theta', Y);

a = theta(1);
b = theta(2);

% Compute transfer function
%yawRateEstimate =  a*yawRate + b*(vx/L).*tan(delta);
%yawRateEstimate =  a*yawRate + b*(vx/L).*delta;
yawRateEstimate =  a*yawRate  + b .*delta;

% Compute transfer function with dynamics adaptation
yawRateEstAdapt(1,1) = 0;
aEst(1) = 0.75;
bEst(1) = 0.25;

for k=1:length(delta)-1 
    
    eYawRate(k) = yawRate(k) - yawRateEstAdapt(k);
    
    aEst(k+1) = aEst(k) + eYawRate(k) * yawRate(k);
    bEst(k+1) = bEst(k) + eYawRate(k) * delta(k);  

    yawRateEstAdapt(k+1,1) = aEst(k+1)* yawRate(k) + bEst(k+1)*delta(k);
%    yawRateEstAdapt(k+1,1) = aEst(k+1) * yawRate(k) + bEst(k+1)*vx(k)/L * tan(delta(k));

         
end

figure;
plot(time,yawRate,'b.-');
hold on;
grid on;
plot(time,[yawRate(1);yawRateEstAdapt(1:end-1)],'r.-');
plot(time,[yawRate(1);yawRateEstimate(1:end-1)],'g.-');
title('Yaw Rate');
xlabel('Time [s]');
ylabel('Yaw Rate [rad/s]');
legend('YawRate','YawRateEstAdaptive','YawRateEst','Location','southeast');


figure;
subplot(2,1,1);
plot(time,aEst,'b.-');
grid on;
title('aEst');
xlabel('Time [s]');
ylabel('aEst[]');

subplot(2,1,2);
plot(time,bEst,'b.-');
grid on;
title('bEst');
xlabel('Time [s]');
ylabel('bEst[]');

figure;
plot(time,[eYawRate 0].^2,'b.-');
grid on;
title('Error of estimation');
xlabel('Time [s]');
ylabel('Error^2');

%%
rmpath('functions');

