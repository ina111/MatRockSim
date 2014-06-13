% ----
% 標準大気モデルを用いた、高度による温度、音速、大気圧、空気密度の関数
% 高度は基準ジオポテンシャル高度を元にしている。
% 標準大気の各層ごとの気温減率から定義式を用いて計算している。
% Standard Atmosphere 1976　ISO 2533:1975
% 中間圏高度86kmまでの気温に対応している。それ以上は国際標準大気に当てはまらないので注意。
% cf. http://www.pdas.com/hydro.pdf
% @param h 高度[m]
% @return T 温度[K]
% @return a 音速[m/s]
% @return P 気圧[Pa]
% @return rho 空気密度[kg/m3]
% 1:	対流圏		高度0m
% 2:	対流圏界面	高度11000m
% 3:	成層圏  		高度20000m
% 4:	成層圏　 		高度32000m
% 5:	成層圏界面　	高度47000m
% 6:	中間圏　 		高度51000m
% 7:	中間圏　 		高度71000m
% 8:	中間圏界面　	高度84852m
% ----
% Future Works:
% ATOMOSPHERIC and SPACE FLIGHT DYNAMICSより
% Standard ATOMOSPHEREのスクリプトに変更して高度2000kmまで対応にする。
% 主に温度上昇と重力加速度とガス状数が変化することに対応すること。
% ----
function [T, a, P, rho] = atmosphere_Rocket( h )
g = 9.80655;
gamma = 1.4;
R = 287.0531;
% height of atmospheric layer
HAL = [0 11000 20000 32000 47000 51000 71000 84852];
% Lapse Rate Kelvin per meter
LR = [-0.0065 0.0 0.001 0.0028 0 -0.0028 -0.002 0.0];
% Tempareture Kelvin
T0 = [288.15 216.65 216.65 228.65 270.65 270.65 214.65 186.95];
% Pressure Pa
P0 = [101325 22632 5474.9 868.02 110.91 66.939 3.9564 0.3734];

if ( h > HAL(1) && h < HAL(2) )
	k = 1;
elseif ( h > HAL(2) && h < HAL(3) )
	k = 2;
elseif ( h > HAL(3) && h < HAL(4) )
	k = 3;
elseif ( h > HAL(4) && h < HAL(5) )
	k = 4;
elseif ( h > HAL(5) && h < HAL(6) )
	k = 5;
elseif ( h > HAL(6) && h < HAL(7) )
	k = 6;
elseif ( h > HAL(7) && h < HAL(8) )
	k = 7;
elseif ( h > HAL(8))
	k = 8;
else
	k = 1;
end

T = T0(k) + LR(k) .* (h - HAL(k));
a = sqrt( T * gamma * R);
if LR(k) ~= 0
	P = P0(k) .* ((T0(k) + LR(k) *(h - HAL(k))) / T0(k)) .^ (g / -LR(k) / R);
else
	P = P0(k) .* exp(g / R * (HAL(k) - h) / T0(k));
end
rho = P / R / T;
