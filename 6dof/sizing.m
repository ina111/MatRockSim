close all

addpath ../quaternion
addpath ../environment
addpath ../aerodynamics
addpath ../mapping
addpath ../gpssim
addpath ..

Isp = 170:10:240;
div = 20;
% output = zeros(length(Isp),div);
weight_dry = zeros(length(Isp), div);
weight_prop = zeros(length(Isp), div);
weight_all = zeros(length(Isp), div);
massratio = zeros(length(Isp), div);
Isp_legend = zeros(length(Isp), 1);
for i = 1:length(Isp)
    [weight_dry(i,:), weight_prop(i,:), ...
        weight_all(i,:), massratio(i,:)] = sizing_plot(Isp(i), 0.4);
    
%     weight_dry = output(1,:);
%     weight_prop = output(2,:);
%     weight_all = output(3,:);
%     massratio = output(4,:);
    Isp_legend(i) = Isp(i);
end

Isp_legend = num2str(Isp_legend);
figure(1);
plot(weight_dry', weight_all');
title('Dry Weight vs Total Weight')
xlabel('Dry Weight (kg)')
ylabel('Total Weight (kg)')
legend(Isp_legend);
grid on

figure(2)
plot(weight_dry', weight_prop');
title('Dry Weight vs Propulsion Weight')
xlabel('Dry Weight (kg)')
ylabel('Propulsion Weight (kg)')
legend(Isp_legend);
grid on

figure(3)
plot(weight_dry', massratio');
title('Dry Weight vs Mass ratio')
xlabel('Dry Weight (kg)')
ylabel('Mass ratio (-)')
legend(Isp_legend);
grid on

