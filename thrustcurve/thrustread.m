function engine = thrustread( filename )
% THRUSTREAD RASPフォーマットの推力履歴を読み込む
% @param filename RASPフォーマットのファイル

[fid, msg] = fopen(filename);

% header skip
a = fgetl(fid);
while (a(1) == ';')
    a = fgetl(fid);
end
% data read
data = strsplit(a, ' ');
engine.name = data(1);
engine.diameter = str2double(data(2));
engine.length = str2double(data(3));
engine.delays = data(4);
engine.propWeight = str2double(data(5));
engine.totalWeight = str2double(data(6));
engine.manufacturer = data(7);
engine.thrust = fscanf(fid, '%f %f', ([2, inf]));
engine.thrust = [[0;0] engine.thrust];

fclose(fid);

plot(engine.thrust(1,:), engine.thrust(2,:))
title(['thrustcurve: ' engine.name]);
xlabel('time [sec]');
ylabel('thrust [N]');

end