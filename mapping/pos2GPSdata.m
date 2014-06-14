function [] = pos2GPSdata ( filename, time, u, e, n, xr, yr, zr, time_ref, day_ref )
% 緯度経度高度の情報から擬似的なGPSデータ（$GPGGA)を作る。
% Google Earthに読み込ませるためにわざわざ作る。
% filename:ファイル名
% time[:]:time_refからの経過時間[s]
% blh[:,3]:緯度経度高度[緯度、経度、高度][deg deg m]
% time_ref:JST time[HHMMSS.SS] ex.123456.78
% day_ref:UTC year,month,day[1x3][year, month, day] ex.[2013, 10,1]
fileaddress = strcat('output/',filename,'.nmea');
[fid, msg] = fopen(fileaddress, 'w');

[ecef_x, ecef_y, ecef_z] = launch2ecef(u, e, n, xr, yr, zr);
[phi, lambda, h] = ecef2blh(ecef_x, ecef_y, ecef_z);

len = length(phi);

for i = 1:len
	% $GPGGAセンテンス生成
	time_UTC = elapsedtime2GPS_UTC(time(i),time_ref);	% UTC現在時間
	latitude = blh_deg2blh_GPSformat(phi(i));		% 緯度
	longitude = blh_deg2blh_GPSformat(lambda(i));	% 経度
	height = h(i);
	str1 = '$GPGGA,';
	str2 = sprintf('%09.2f,%10.6f,N,%011.6f,', time_UTC, latitude, longitude);
	str3 = sprintf('E,1,08,0.9,%.2f,M,28.4,M,,,*', height);	
	str_file = strcat(str1, str2, str3);
	str_checksum = make_checksum_nmea(str_file);
	str_file = strcat(str_file, str_checksum, '\n');
	fprintf(fid, str_file);

	% $GPZDAの日付センテンス生成
	str4 = sprintf('$GPZDA,%09.02f,%02d,%02d,%04d,00,00*', time_UTC, day_ref(3), day_ref(2),day_ref(1));
	str_checksum = make_checksum_nmea(str4);
	str_file = strcat(str4, str_checksum, '\n');
	fprintf(fid, str_file);
end
fclose(fid);
end

function output = make_checksum_nmea(str)
% NMEAセンテンスのチェックサム作成
% '$GPGGA,~~~,M,,0000*'までの文字列を読み込んでチェックサム(8bitの16進数表記0x**)出力
% “$”、”!”、”*”を含まないセンテンス中の全ての文字 の8ビットの排他的論理和。","は含むので注意
% ex. $GPGGA,125044.001,3536.1985,N,13941.0743,E,2,09,1.0,12.5,M,36.1,M,,0000*6A
num_str = length(str);
checksum = uint8(0);
for i = 1:num_str
	if (str(i) ~= '$') && (str(i) ~= '!') && (str(i) ~= '*')
		checksum = bitxor(checksum, uint8(str(i))); % bit数の排他的論理和XOR
	end
end
output = sprintf('%02X',checksum);
end

function output = blh_deg2blh_GPSformat(pos)
% 緯度経度[deg]からNMEAのセンテンス形式に変換する関数
% ex.緯度48.1167***度をNEMAフォーマットの4807.03***の分刻みに変換
% [DD.DDDDDDDD]->[DDMM.MMMMMM](D:度,M:分)
% pos:緯度経度[deg]([DD.DDDDDDDD])
% output_str:NMEAフォーマットの緯度経度の文字列[DDMM.MMMMMM]
degree = fix(pos);	% 小数点以下切り捨て
minute = (pos - degree) * 60;
output = degree * 100 + minute;
end

function output = elapsedtime2GPS_UTC(time,time_ref)
% 基準時刻(time_ref)とコンピュータ時間(time)を足してタイムスタンプ生成（UTC）
% time:time_refからの経過時間[s] class(float)
% time_ref:JST time[HHMMSS.SS] class(float)
% output:UTC time[HHMMSS.SS] class(float)
hour = 0;
minute = 0;
while time > 3600
	hour = hour + 1;
	time = time - 3600;
end
while time > 60
	minute = minute + 1;
	time = time - 60;
end
output = time_ref - 90000 + (hour * 10000 + minute * 100 + time);
end
