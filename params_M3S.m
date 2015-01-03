% ---- グローバル変数の設定（いじらない） ----
global ROCKET
global VWH
global para_Cd para_S

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
% VWH:　水平座標系においての風速(Up-East-North) [m/s] (3x1)
ROCKET = struct( ...
'm0', 45247.4, ...
'Isp', 266, ...
'g0', 9.80665, ...
'FT', [1147000], ...
'Tend', [53], ...
'At', 0.63, ...
'Area', 1.41^2 / 4 * pi, ...
'CLa', 3.5, ...
'length_GCM', [-9.76; 0; 0], ...
'length_A', [-1.0; 0; 0], ...
'Ijj', [188106; 188106; 1839], ...
'IXXdot', 0, ...
'IYYdot', 0, ...
'IZZdot', 0, ...
'azimth', 135, ...
'elevation', 88 ...
);

VWH = [0; 0; 0];

% ---- パラシュート ----
% para_exist : パラシュートがあるかどうか[true,false]
% para_Cd: パラシュート抗力係数[-]
% para_Dia: パラシュート開傘時の直径[m]
% para_S: パラシュート面積[m2]
para_exist = false;
para_Cd = 1.0;
para_Dia = 1.5;
time_parachute = 399;
para_S = para_Dia * para_Dia / 4 * pi;

% ---- 常微分方程式に使う状態量の初期化 ----
% pos0: 射点中心慣性座標系における位置（Up-East-North)[m] (3x1)
% vel0: 射点中心慣性座標系における速度[m/s] (3x1)
% quat0: 機体座標系から水平座標系に変換を表すクォータニオン[-] (4x1)
% omega0: 機体座標系における機体に働く角速度[rad/s] (3x1)
pos0 = [0.0; 0.0; 0.0]; % m
vel0 = [0.0; 0.0; 0.0]; % m/s
quat0 = attitude(ROCKET.azimth, ROCKET.elevation);
omega0 = [0.0; 0.0; 0.0]; % rad/s
x0 = [ROCKET.m0; pos0; vel0; quat0; omega0];


% ---- mappingのための変数 ----
% filename: outputフォルダに出力するKML,HTMLファイルのファイル名(string)
% launch_phi,lambda, h: 射点の緯度経度高度、度表示[deg][deg][m]
% time_ref: 発射時刻[HHMMSS.SS] 例. 12時34分56.78秒→123456.78
% day_ref: 発射日[year, month, day] 例. 2014年1月1日→[2014, 1, 1]
% ---- 参考 ----
% 能代宇宙イベント第3堆積場射点 [40.1408, 139.9860, 20]
% 伊豆大島裏砂漠射点 [34.731059, 139.415917, 465]
% 内之浦宇宙空間観測所（ミューセンター）[31.251008, 131.082301]
filename = 'test';
launch_phi = 31.251008; % 43.5807
launch_lambda = 131.082301; % 142.002083
launch_h = 194; % 50
time_ref=123456.78;
day_ref = [2013, 10,1];
[xr, yr, zr] = blh2ecef(launch_phi, launch_lambda, launch_h);



