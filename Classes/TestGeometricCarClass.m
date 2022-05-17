%TestGeometricCarClass
%13/11/2020

close all;
clear;
clc;

addpath('../Classes');

T = 0.04;
l = 2.5;

 % Init Car
 carInit = struct('t', 0, 'x', 0, 'y', 0, 'v_x', 5/3.6, 'v_y', 0, 'yaw', pi/2, 'yawRate', 0);
       
 %% Parameters
 % TEST FUNCTION
 geometricCar = GeometricModel('T', T, 'l', l, 'Init', carInit);
 car = geometricCar;

 % TEST CLASS
 carObject = GeometricCar('T', T, 'l', l, 'initStates', carInit);
 
 %% Simulation 
 carStates(1) = car.getStates(car);
 carObjectStates(1) = getStates(carObject);
 
%  carStep = struct('t', 0, 'x', 1, 'y', 1, 'v_x', 5/3.6, 'v_y', 0, 'yaw', pi/2, 'yawRate', 0);
%  car = car.setStates(car, carStep);
%  carObject = setStates(carObject, carStep);
%  carStates(2) = car.getStates(car);
%  carObjectStates(2) = getStates(carObject);
 
 for k=1:50   
    car   = car.update(car, deg2rad(200), 5/3.6);
    carObject = update(carObject, deg2rad(200), 5/3.6);
    carStates(k+1) = car.getStates(car);
    carObjectStates(k+1) = getStates(carObject);
 end
 
 %% Test Plot
 figure(1);
 plot([carStates.x], [carStates.y], 'b.-');
 hold on;
 plot([carObjectStates.x], [carObjectStates.y], 'ro-');
 axis equal;
 grid on;
 xlabel('x [m]');
 ylabel('y [m]');
 
 rmpath('../Classes');