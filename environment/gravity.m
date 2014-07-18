function [gc, gnorth] = gravity( h, lat )
% GRAVITY 地球を自転軸回りの回転楕円体と仮定し、Jefferyの帯球係数を第2項まで考慮した
% 重力加速度を求める。
% 遠心力は考慮していないので、地面固定の重力加速度と比較すると
% 小さな値が出力される。
% @param h 高度[m]
% @param lat 緯度[rad]
% @return gc 地球中心方向重力加速度[m/s2]
% @return gnorth 北方向重力加速度[m/s2]
% 航空宇宙工学便覧のP865は北方向の重力加速度を間違っているので注意。

mu = 3.986004e14;
Re = 6378.135e3;
J2 = 1.08263e-3;
epsilon = 1 / 298.257;
r = h + Re * (1 - epsilon * sin(lat) ^2);

gc = - mu / r^2 * (1 - 1.5 * J2 *(Re/r)^2 * (3*sin(lat)^2 - 1));
gnorth = mu / r^2 * J2 * (Re/r)^2 * sin(2*lat);