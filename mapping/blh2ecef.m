% ----
% 緯度経度高度からECEF座標に変換
% 緯度経度高度のドイツ語読みの頭文字BLH
% 地球中心地球固定座標ECEF(Earth Centered Earth Fixed)
% @param phi:緯度[deg]
% @param ramda:経度[deg]
% @param height:WGS84の平均海面高度[m]
% @return x,y,z:ECEF座標での位置[m]
% ----
function [x, y, z] = blh2ecef(phi, ramda, height)
% ---- WGS84の定数定義 ----
pi_GPS = 3.1415926535898; % GPS関連で使われるπの定数
a = 6378137.0;	% WGS84の長軸[m]
one_f = 298.257223563;	% 扁平率fの1/f（平滑度）
b = a * (1.0 - 1.0 / one_f);	% WGS84の短軸[m] b = 6356752.314245
e2 = (1.0 / one_f) * (2.0 - (1.0 / one_f));	% 第一離心率eの2乗
ed2 = (e2 * a * a / (b * b));	% 第二離心率e'の2乗
% n = inline(a / sqrt(1.0 - e2 * sin(deg2rad(phi))^2), 'phi');
n = a ./ sqrt(1.0 - e2 .* sin(deg2rad(phi)).^2);	% その緯度でのWGS84楕円体高
% ---- 定数定義終了 ----
x = (n + height) .* cos(deg2rad(phi)) .* cos(deg2rad(ramda));
y = (n + height) .* cos(deg2rad(phi)) .* sin(deg2rad(ramda));
z = (n * (1 - e2) + height) .* sin(deg2rad(phi));