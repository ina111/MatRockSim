%　標準大気モデルと重力加速度モデルの高度分布が合っているかテスト
close all,clear all

% 最大高度[m]と緯度[deg]
max_height = 100000;
latitude = 42;

height = 1:100:max_height;
T = zeros(1,length(height));
a = zeros(1,length(height));
P = zeros(1,length(height));
rho = zeros(1,length(height));
g = zeros(1,length(height));
gnorth = zeros(1,length(height));
for i= 1:length(height)
    [T(i), a(i), P(i), rho(i)] = atmosphere_Rocket(height(i));
    [g(i),gnorth(i)] = gravity(height(i), latitude/180*pi);
end

figure();
plot(T,height / 1000);
title('temperature');
xlabel('temperature [K]')
ylabel('altitude [km]')

figure();
plot(a, height / 1000);
title('sound speed');
xlabel('sound speed [m/s]')
ylabel('altitude [km]')

figure()
plot(P, height / 1000);
title('pressure');
xlabel('pressure [Pa]')
ylabel('altitude [km]')

figure()
plot(rho, height / 1000);
title('air density');
xlabel('air density [kg/m3]')
ylabel('altitude [km]')

figure()
plot(-g, height / 1000);
title('gravity');
xlabel('gravity accelaration [m/s2]')
ylabel('altitude [km]')


