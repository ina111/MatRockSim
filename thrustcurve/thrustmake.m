function [ ] = thrustmake( filename, thrust , endtime )
%THRUSTMAKE 一定推力の推力履歴のRASPフォーマットを出力する。
% @param filename 出力するファイル名
% @param thrust 一定推力[N]
% @param endtime 燃焼終了時刻[s]
[fid, msg] = fopen(filename, 'w');
fprintf(fid, 'hoge 0 0 hoge 0 0 hoge\n');

time = [0.1; endtime; endtime + 0.1];
thrustcurve = [thrust; thrust; 0];
for i = 1:length(time)
    fprintf(fid, '%f %f\n', time(i), thrustcurve(i));
end
fclose(fid);
end
