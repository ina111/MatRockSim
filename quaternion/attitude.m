% ----
% 初期の方位角と仰角[deg]からクォータニオン生成
% @param azimth_deg: 方位角[deg] (1x1)
% @param elevation_deg: 仰角[deg] (1x1)
% @return quat: クォータニオン[-] (4x1)
% ----
function quat = attitude(azimth_deg, elevation_deg)
	azimth_rad = azimth_deg/180.0*pi;
	quat_az = [cos(-0.5*azimth_rad) sin(-0.5*azimth_rad)*[1 0 0]];
	elevation_rad = elevation_deg/180.0*pi;
	roty = elevation_rad-0.5*pi;
	quat_el = [cos(-0.5*roty) sin(-0.5*roty)*[0 1 0]];
	quat = quatmultiply(quat_el, quat_az)';
end
