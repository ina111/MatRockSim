% ---- 初期化用 ---- 
clear all; close all;

addpath .
addpath ./quaternion
addpath ./environment
addpath ./aerodynamics
addpath ./mapping

ROCKET = params_rocket();
quat0 = attitude(ROCKET.azimth, ROCKET.elevation)';
x0 = [ROCKET.m0; ROCKET.pos0; ROCKET.vel0; quat0; ROCKET.omega0];

% angle0 = [0.0; (ROCKET.elevation-90)*pi/180; 0.0];
Tr = 0.0;
VWH = [0.0; 0.0; 0.0];

tau_delta = 0.5; % ジンバル遅れ[s]
K = [-4.2029e-03 -3.4474e-01 -1.5683e-01 0.0000 -1.0000e-02];   % ジンバル角無し簡易版
% K = [-8.4584e-03 -3.6897e-01 -2.1079e-01 1.1548e+00 -1.0000e-02];   % ジンバル遅れ考慮版

