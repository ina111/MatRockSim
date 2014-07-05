function [phi, lambda, height] = ecef2blh(x, y, z)
% ECEF2BLH ECEF座標から緯度経度高度に変換
% 緯度経度高度のドイツ語読みの頭文字BLH
% 地球中心地球固定座標ECEF(Earth Centered Earth Fixed)
% @param x,y,z: ECEF座標での位置[m]
% @return phi: 緯度[deg]
% @return lambda: 経度[deg]
% @return height: WGS84の平均海面高度[m]

% ---- WGS84の定数定義 ----
pi_GPS = 3.1415926535898; % GPS関連で使われるπの定数
a = 6378137.0;	% WGS84の長軸[m]
one_f = 298.257223563;	% 扁平率fの1/f（平滑度）
b = a * (1.0 - 1.0 / one_f);	% WGS84の短軸[m] b = 6356752.314245
e2 = (1.0 / one_f) * (2.0 - (1.0 / one_f));	% 第一離心率eの2乗
ed2 = (e2 * a * a / (b * b));	% 第二離心率e'の2乗
n = @(phi_n) a ./ sqrt(1.0 - e2 .* sin(deg2rad(phi_n)).^2); % 無名関数
% n = a ./ sqrt(1.0 - e2 .* sin(deg2rad(phi)).^2);	% その緯度でのWGS84楕円体高
p = sqrt(x.^2 + y.^2);	% 現在位置での地心からの距離[m]
theta = atan2(z.*a, p.*b);	% [rad]
% --- 定数定義終了 ---
phi = rad2deg(atan2((z + ed2 .* b .* sin(theta).^3), p - e2 * a * cos(theta).^3));
lambda = rad2deg(atan2(y,x));
height = p ./ cos(deg2rad(phi)) - n(phi);
