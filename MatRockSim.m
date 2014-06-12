% ===== RocketSim =====
% 6自由度の運動を行う飛翔体の飛翔シミュレータ
% Matlab2014RとOctave3.6.4で動作を確認。
% 
% Copyright (C) 2014, Takahiro Inagawa
% This program is free software under MIT license.
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

% ---- パラメータ設定読み込み ----
params

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
