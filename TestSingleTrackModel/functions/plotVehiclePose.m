% plotVehiclePose.m
% 15/10/2018

function plotVehiclePose(ax, x, y, yaw)
    quiver(ax, x, y, 1 * cos(yaw), 1 * sin(yaw), 'b', 'LineWidth', 2);
    hold on
    plot(ax,x, y,'bo','MarkerSize',5,'MarkerFaceColor',[0.25,0.25,0.25]);
end