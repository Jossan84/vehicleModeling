%2019/02/27

delta_steering = -1300:0.1:1300;
L = 2.7;
R = L:1:50;
sr = 15.8;


%Wheel angle
delta_s = delta_steering * 1/sr; 


% tanDelta = rad2deg(tand(delta_s));  % El valor que devuelve  tand es en
                                      % radianes
                                      
tanDelta = rad2deg(tan(deg2rad(delta_s)));

figure(1);
plot(delta_s, tanDelta,'b.-');
hold on;
plot(delta_s,delta_s,'r.-');
hold off;
title('Delta vs tanDelta');
ylabel('tanDelta');
xlabel('delta');

figure(2);
plot(delta_s, abs(delta_s - tanDelta),'b.-');
title('error delta vs tanDelta');
ylabel('error');
xlabel('delta');



