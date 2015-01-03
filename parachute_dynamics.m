% ----
% cd http://airex.tksc.jaxa.jp/dr/prc/japan/contents/NALTM0368000/naltm00368.pdf
% ----

function [ dx ] = parachute_dynamics( t, x )
% x(1): mass 質量[kg]
% x(2): X_H 射点座標位置[m]
% x(3): Y_H 射点座標位置[m]
% x(4): Z_H 射点座標位置[m]
% x(5): VX_H 射点座標対地速度[m/s]
% x(6): VY_H 射点座標対地速度[m/s]
% x(7): VZ_H 射点座標対地速度[m/s]
% x(8): q0 quaternion Body to Horizon[-]
% x(9): q1 quaternion Body to Horizon[-]
% x(10): q2 quaternion Body to Horizon[-]
% x(11): q3 quaternion Body to Horizon[-]
% x(12): omegaX 機体座標系の角速度[rad/s]
% x(13): omegaY 機体座標系の角速度[rad/s]
% x(14): omegaZ 機体座標系の角速度[rad/s]
% ----

% パラシュート直径、面積、抗力係数
global VWH
global para_Cd para_S

% 空気密度、重力加速度
[~, a, P, rho] = atmosphere_Rocket(x(2));
[gc, gnorth] = gravity(x(2), 35*pi/180);

% 速度の運動方程式
if x(5) > 0
	delta_V = gc - 0.5 / x(1) * rho * para_Cd * para_S * x(5) * x(5);
else
	delta_V = gc + 0.5 / x(1) * rho * para_Cd * para_S * x(5) * x(5);
end

dx = [ 0.0;
x(5);
VWH(2);
VWH(3);
delta_V;
0;
0;
0;
0;
0;
0;
0;
0;
0];

end