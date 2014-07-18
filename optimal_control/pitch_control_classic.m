clear all
close all
% ----Constant----
% g: 重力加速度(m/s2)
% mass: 重量(kg)
% force_t: 推力(N)
% L_alpha:
% length_A: 空力中心までの距離(m)
% length_T: ジンバル点までの距離(m)
% theta0: 目標角(垂直方向からの角度)(deg)
% vel_A: 機軸方向速度(m/s)
% Iyy: ピッチ面方向の慣性モーメント(kg*ｍ２)
% muA: 空力項
% muT: 推力項
% ----------------
g = 9.8066;
mass = 70;
force_T = 1000;
L_alpha = 30;
length_A = 0.2;
length_T = 1.5;
theta0 = 0;
vel_A = 10;
Iyy = 84;

muA = L_alpha * length_A / Iyy;
muT = force_T * length_T / Iyy;

% ----ブロック線図----
% 制御プラントP伝達関数: sys_pitch
% PIDコントローラK伝達関数: sys_control
% Kp,Kd,Ki: P制御係数、D制御係数、I制御係数
% sys_control = (Kd*s^2 + Kp*s + Ki) / s
% 一巡伝達関数L: sys_loop
% 閉ループ伝達関数: sys
%   u     +-----------+ y1  u2+---------+     y
%  ------>|sys_control|------>|sys_pitch|------->
%      |  +-----------+       +---------+  |
%      |                                   |
%      |             +------+              |
%      +-------------|  1   |<-------------+
%                    +------+
% ----------------
sys_pitch_num = [muT L_alpha*muT/mass/vel_A*(1+length_A/length_T)]
sys_pitch_den = [1 L_alpha/mass/vel_A -muA muA*g*cos(deg2rad(theta0))/vel_A]
sys_pitch = tf(sys_pitch_num, sys_pitch_den)

Kp = 1;
Kd = 2;
Ki = 0.5;
sys_control = tf([Kd Kp Ki],[1 0])

sys_loop = series(sys_control, sys_pitch)
sys = feedback(sys_loop,[1])

% ----図示
t = 0:0.01:10;
figure()
bode(sys_pitch,t)
print ('PID_PlantBode.jpg')

figure()
bode(sys_control)
print ('PID_ControllerBode.jpg')

figure()
bode(sys)
print ('PID_FeedbackLoopBode.jpg')
figure()
impulse(sys,t)
print ('PID_impulse_response.jpg')
figure()
t = 0:0.01:10;
u = linspace(0.1,0.1,length(t));
lsim(sys,u,t)
print ('PID_step_response.jpg')

% ----安定性確認----
figure()
rlocus(sys)
print ('PID_rlocus.jpg')

figure()
nyquist(sys)
print ('PID_nyquist.jpg')

% % ----cf.PIDコントローラの最適化問題 ----
% % PID: K(s+a)^2/s とする
% % ---------------------------------
% t = 0:0.01:8;
% for K = 0:0.1:10;
% 	for a = 0:0.1:10;
% 		sys_control = tf([K 2*a*K a^2],[1 0]);
% 		sys_loop = series(sys_control, sys_pitch);
% 		sys = feedback(sys_loop,[1]);
% 		y = step(sys,t);
% 		m = max(y);
% 		if m < 1.5 & m > 1.10;
% 			break;
% 		end
% 	end
% 	if m < 1.5 & m > 1.10;
% 		break;
% 	end
% end
% solution = [K a m]
% plot(t,y)
