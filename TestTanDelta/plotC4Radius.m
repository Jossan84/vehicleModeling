% 201902/27

close all;

steering_wheel_angle = deg2rad(linspace(0,550,550));
L = 2.73;
Steering_Ratio = 15.8;

R = L./tan(steering_wheel_angle*(1/Steering_Ratio)); %Assuming L/tan(delta)
R1 = L./(steering_wheel_angle*(1/Steering_Ratio));   %Assuming L/delta

figure(1);
semilogy(rad2deg(steering_wheel_angle),R,'b.-');
hold on;
semilogy(rad2deg(steering_wheel_angle),R1,'r.-');
title('Radius')
ylabel('R [m]');
xlabel('\wp [deg]');
grid on;
legend('L/tan(delta)','L/delta');

figure(2);
plot(rad2deg(steering_wheel_angle), abs(R1-R),'b.-');
title('Error between two equations')
ylabel('e [m]');
xlabel('\wp [deg]');
grid on;

Rs = 1000:-1:3; % Linear values of radius

figure(3);
semilogy(Rs, rad2deg(atan(L./Rs)*Steering_Ratio),'b.-');
hold on;
semilogy(Rs,rad2deg(L./Rs)*Steering_Ratio,'r.-');
grid on;
title('Steering Wheel Angle');
ylabel('\wp [deg]');
xlabel('R [m]');
legend('L/tan(delta)','L/delta');



