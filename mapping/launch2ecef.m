% ----
% 射点座標系からECEF座標系へ座標変換
% @param u,e,n 射点中心座標系のUp-East-North座標[m] (nx1)x3
% @param xr,yr,zr ECEF座標上の参照位置（射点）:[m] (1x1)x3
% @return x,y,z ECEF座標系上の座標[m] (nx1)x3
% ----
function [x, y, z] = launch2ecef(u, e, n, xr, yr, zr)
% 射点の緯度経度
[phi, ramda, height] = ecef2blh(xr,yr,zr);
phi = deg2rad(phi);
ramda = deg2rad(ramda);
x = -sin(phi)*cos(ramda)*n - sin(ramda)*e - cos(phi)*cos(ramda)*(-u) + xr;
y = -sin(phi)*sin(ramda)*n + cos(ramda)*e - cos(phi)*sin(ramda)*(-u) + yr;
z = cos(phi)*n - sin(phi)*(-u) + zr;