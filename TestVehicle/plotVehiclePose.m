% plotVehiclePose.m
% 15/10/2018

function plotVehiclePose(ax, x, y, yaw)

    %hold(ax,'on');
    
    % Plot axis
    quiver(ax, x, y, 1 * cos(yaw), 1 * sin(yaw), 'r', 'LineWidth', 2); % [x]
    quiver(ax, x, y, 1 * -sin(yaw), 1 * cos(yaw), 'g', 'LineWidth', 2);% [y]
    % TBD % [z]
    
    % Plot position
    plot(ax,x, y,'ko','MarkerSize',5,'MarkerFaceColor',[0.25,0.25,0.25]);
    
end