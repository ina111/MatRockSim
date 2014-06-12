% ===== RocketSim =====
% 6自由度の運動を行う飛翔体の飛翔シミュレータ
% Matlab2014RとOctave3.6.4で動作を確認。
% 
% Copyright (C) 2014, Takahiro Inagawa
% 
% This program is free software under MIT license.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
% ======================
clear global;  clear all; close all;

addpath ./quaternion
addpath ./environment
addpath ./aerodynamics

global Isp g0
global FT Tend At CD CLa area
global length_GCM length_A
global IXX IYY IZZ
global IXXdot IYYdot IZZdot

% ---- パラメータ設定 ----
% m0: 初期質量[kg]
% Isp: 比推力[sec]
% g0: 地上での重力加速度[m/s2]
% FT: 推力[N]
% Tend: 燃焼時間[sec]
% At: スロート径[m2]
% area: 機体の断面積[m2]
% CLa: 揚力傾斜[/rad]
% CD: 抗力係数[-]
% length_GCM: エンジンピボット点からの重心位置ベクトル[m](3x1)
% length_A: エンジンピボット点からの空力中心点位置ベクトル[m] (3x1)
% IXX,IYY,IZZ: 慣性モーメント[kgm2]
% IXXdot,IYYdot,IZZdot: 慣性モーメントの時間変化[kgm2/sec]
% azimth, elevation: 初期姿勢の方位角、仰角[deg]
m0 = 4.0;
Isp = 200;
g0 = 9.8;
FT = 150;
Tend = 4;
At = 0.01;
area = 0.010;
CLa = 3.5;
% CD = 0.32;
length_GCM = [-0.70; 0; 0]; length_A = [-0.50; 0; 0];
IXX = 5; IYY = 5; IZZ = 1;
IXXdot = 0; IYYdot = 0; IZZdot = 0;
azimth = 45; elevation = 80;

% ---- 常微分方程式に使う状態量の初期化 ----
% pos0: 射点中心慣性座標系における位置（Up-East-North)[m] (3x1)
% vel0: 射点中心慣性座標系における速度[m/s] (3x1)
% quat0: 機体座標系から水平座標系に変換を表すクォータニオン[-] (4x1)
% omega0: 機体座標系における機体に働く角速度[rad/s] (3x1)
pos0 = [0.0; 0.0; 0.0]; % m
vel0 = [0.0; 0.0; 0.0]; % m/s
quat0 = attitude(azimth, elevation);
omega0 = [0.0; 0.0; 0.0]; % rad/s
x0 = [m0; pos0; vel0; quat0; omega0];

% ---- 常微分方程式 ----
AbsTol = [1e-4; % m
          1e-4; 1e-4; 1e-4; % pos
          1e-4; 1e-4; 1e-4; % vel
          1e-4; 1e-4; 1e-4; 1e-4; %quat
          1e-3; 1e-3; 1e-3]; % omega
options = odeset('Events', @events_land, 'RelTol', 1e-3, 'AbsTol', AbsTol);

disp('Start Simulation...');
tic
[T, X] = ode23s(@rocket_dynamics, [0 40], x0, options);
toc

% --------------
%     plot
% --------------
figure()
plot(T,X(:,1))
title('Weight')
xlabel('Time [s]')
ylabel('Weight [kg]')
grid on

figure()
plot(T,X(:,2),'-',T,X(:,3),'-',T,X(:,4),'-')
title('Position')
xlabel('Time [s]')
ylabel('Position [m]')
legend('Altitude','East','North')
grid on

figure()
plot(T,X(:,5),'-',T,X(:,6),'-',T,X(:,7),'-')
title('Velocity')
xlabel('Time [s]')
ylabel('Velocity [m/s]')
legend('Altitude','East','North')
grid on

figure()
plot(T,X(:,8),'-',T,X(:,9),'-',T,X(:,10),'-',T,X(:,11),'-')
title('Attitude')
xlabel('Time [s]')
ylabel('Quaternion [-]')
legend('q0','q1','q2','q3')
grid on

figure()
plot(T,X(:,12),'-',T,X(:,13),'-',T,X(:,14),'-')
title('Angler Velocity')
xlabel('Time [s]')
ylabel('Angler Velocity [rad/s]')
legend('omega x','omega y','omega z')
grid on

% coordinate: Up-East-North
figure()
plot3(X(:,3),X(:,4),X(:,2),0,0,0,'x');
grid on
xlabel('East');
ylabel('North');
% プロットをキレイにするための調整
plot3_height = max(X(:,2));
plot3_width_east = max(X(:,3)) - min(X(:,3));
plot3_width_north = max(X(:,4)) - min(X(:,4));
plot3_width_max = max([plot3_height; plot3_width_east; plot3_width_north])*1.1;
if min(X(:,3)) < 0
    xlim([min(X(:,3))*1.1 min(X(:,3))*1.1+plot3_width_max]);
else
    xlim([0 plot3_width_max*1.1]);
end
if min(X(:,4)) < 0
    ylim([min(X(:,4))*1.1 min(X(:,4))*1.1+plot3_width_max]);
else
    ylim([0 plot3_width_max*1.1]);
end
if plot3_height < plot3_width_max
    zlim([0 plot3_width_max]);
else
    zlim([0 plot3_height*1.1]);
end
