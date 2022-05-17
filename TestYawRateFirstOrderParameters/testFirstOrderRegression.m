%testFirstOrderRegression
%17/10/2019

close all;
clear;
more off;
clc;

addpath('functions');
addpath('data');

T     = 0.02; % [s]
tInit = 0; % [s]
tEnd  = 10;% [s]
uStep = 1;% []

% Time
t = (tInit:T:tEnd-T);

% System Parameters
% Gain = 1 -->(1=(b/(1-a)))
a = 0.75;
b = 0.25;
x0 = 0;

%u = stepU(uStep,T,tEnd,0);  % [Step Input]
u = sineU(uStep,T,tEnd,60); % [Sine Input]
%u = rand(size(t'));         % [Random Input]

%% Transfer Function Response
N = length(t);

y = zeros(1,N);
y(1) = 0;
error(1) = 0;
yEst(1) = 0;
U = 0;
aOnlineEst(1) = 0.6;
bOnlineEst(1) = 0.2;
for k=1:N
    
    error(k) = y(k) - yEst(k); 
    
    aOnlineEst(k+1) = aOnlineEst(k) + error(k) * y(k);%y(k)/(1+y(k)^2);
    bOnlineEst(k+1) = bOnlineEst(k) + error(k) * u(k);%U/(1+U^2);
    
    y(k+1) = transferFunction(u(k),y(k),a,b);
    %y(k+1) = transferFunction(u(k),y(k),a,b) + 0.001*rand(1); %Add noise
    
    yEst(k+1) = aOnlineEst(k+1)*y(k) + bOnlineEst(k+1)*u(k);     
    U = u(k);
    
end

%% Offline Parameter Estimation

%First Method: [Free Gain]
%Estimate a,b
Y = y(2:end)';
X = [(y(1:end-1)'),u];
[theta] = normalEqn(X, Y);
J = costFunction(X, theta', Y);
aOfflineEst = theta(1);
bOfflineEst = theta(2);

% % Second Method: [Gain = 1 -->(1=(b/(1-a)))]
% % Estimate a
% Y = (y(2:end)') - u;
% X = (y(1:end-1)') - u;
% 
% [theta] = normalEqn(X, Y);
% J = costFunction(X, theta', Y);
% aOfflineEst = theta;
% bOfflineEst = 1 - aEstimated;

%% Plot
figure;
ax = gca;
plot(ax,t,u,'b.-');
hold(ax, 'on');
plot(ax,t,y(1:end-1),'r.-');
xlabel(ax, 'Time [s]');
grid(ax, 'on');

figure;
grid on;
plot(t,y(1:end-1),'b.-');
hold on;
grid on;
plot(t,yEst(1:end-1),'r.-');
xlabel('Time [s]');

figure;
subplot(2,1,1);
plot(t,aOnlineEst(1:end-1),'b.-');
grid on;
ylabel('aEst');
xlabel('Time [s]');
subplot(2,1,2);
plot(t,bOnlineEst(1:end-1),'b.-');
grid on;
ylabel('bEst');
xlabel('Time [s]');

rmpath('functions');
rmpath('data');
