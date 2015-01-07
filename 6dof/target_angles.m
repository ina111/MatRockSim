function quat = target_angles ( t )
    % 機体の姿勢スケジュール
    % @param t: 現在時刻[sec] (1x1)
    % @return quat: 姿勢のクォータニオン[-] (1x4)
    % euler_maneuver例えば、アジマス45度、ピッチ80度のとき[0, 10, 45](deg)
    % ====
    time_maneuver = [0, 2];
    euler_maneuver = [0 5 45; ...
                      0 5 45];
    euler_maneuver = deg2rad(euler_maneuver);
    for i = 1:length(time_maneuver)
        if t >= time_maneuver(i)
            euler = euler_maneuver(i,:);
        end
    end
    yaw = euler(1);pitch = euler(2);roll = euler(3);
%     quat = euler2quat(euler);
    quat = angle2quat(yaw, pitch, roll);
end