close all

addpath ../quaternion
addpath ../environment
addpath ../aerodynamics
addpath ../mapping
addpath ../gpssim
addpath ..

% Isp = 170:10:240;
Isp = 170:10:240;
div = 20;
weight_dry = zeros(length(Isp), div);
weight_prop = zeros(length(Isp), div);
weight_all = zeros(length(Isp), div);
massratio = zeros(length(Isp), div);
weight_tank2 = zeros(length(Isp), div);
Isp_legend = zeros(length(Isp), 1);
burn_time_array = zeros(length(Isp), div);
for i = 1:length(Isp)
    [weight_dry(i,:), weight_prop(i,:), ...
        weight_all(i,:), massratio(i,:), ...
        burn_time_array(i,:)] = sizing_plot(Isp(i), 0.4);
    
    for j = 1:div
        weight_tank2(i,j) = weight_tank(weight_prop(i,j), 0.2);
    end
    Isp_legend(i) = Isp(i);
end

% ------------
%     plot 
% ------------
Isp_legend = num2str(Isp');
figure(1);
plot(weight_dry', weight_all');
title('Dry Weight vs Total Weight')
xlabel('Dry Weight (kg)')
ylabel('Total Weight (kg)')
ylim([0 inf]);
legend(Isp_legend);
grid on

figure(2)
plot(weight_dry', weight_prop');
title('Dry Weight vs Propulsion Weight')
xlabel('Dry Weight (kg)')
ylabel('Propulsion Weight (kg)')
ylim([0 inf]);
legend(Isp_legend);
grid on

figure(3)
plot(weight_dry', massratio');
title('Dry Weight vs Mass ratio')
xlabel('Dry Weight (kg)')
ylabel('Mass ratio (-)')
legend(Isp_legend);
ylim([1 inf]);
grid on

figure(4);
x = min(weight_dry(1,:)):max(weight_dry(1,:));
plot(weight_dry', weight_tank2', x, x);
title('Tank Weight, Dry Weight')
xlabel('Dry Weight (kg)')
ylabel('Weight (kg)')
ylim([0 inf]);
legend(Isp_legend);
grid on

figure(5);
plot(weight_dry', weight_all' - weight_tank2' - weight_prop');
title('(Total Weight) - (Prop + Tank Weight)')
xlabel('Dry Weight (kg)')
ylabel('Weight (kg)')
legend(Isp_legend);
grid on

figure(6);
plot(weight_dry', burn_time_array');
title('Dry Weight vs Burn time')
xlabel('Dry Weight (kg)')
ylabel('burn time (s)')
legend(Isp_legend);
grid on
